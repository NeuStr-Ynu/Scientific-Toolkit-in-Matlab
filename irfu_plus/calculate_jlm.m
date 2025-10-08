function [OUT_jlm] = calculate_jlm(B, Vi, Tint_era, method)
%CALCULATE_JLM  Estimate current density in the L and M directions using magnetic field and ion velocity data.
%
% This function calculates the current density components jl and jm in the LMN coordinate system
% based on the method proposed in Guo et al. (2025):
%       jm = (c/4π) * (1/vn) * (∂Bl/∂t)
%       jl = −(c/4π) * (1/vn) * (∂Bm/∂t)
%
% INPUTS:
%   B         : Magnetic field data
%   Vi        : Ion velocity data
%   Tint_era  : Time interval or window length for estimation (in seconds or time object)
%   method    : Method for estimation (string)
%               'sliding' - use a sliding window
%               'single'  - use a single fixed window
%
% OUTPUT:
%   OUT_jlm   : A structure containing:
%               jl - current density in the L direction (A/m^2)
%               jm - current density in the M direction (A/m^2)
%
% Note:
% - The calculation assumes data is already transformed into LMN coordinates.
% - vn is the component of ion velocity in the N direction.
%% arguments
arguments (Input)
    B TSeries
    Vi TSeries
    Tint_era double 
    method char
end

arguments (Output)
    OUT_jlm struct
end

if method~="sliding" && method~="single"
    error(['methord error only sliding and single are supported.'])
end
%% main code
mu0 = pi*4e-7;% 真空磁导率

switch method
    case "sliding"
        
        jm=zeros(length(B.time.epoch),1);
        jl=zeros(length(B.time.epoch),1);
        B=zeros(length(B.time.epoch),3);
        Vi=zeros(length(B.time.epoch),3);
        for i=1:length(B.time.epoch)
        
            disp(['calculating ...',num2str(i),'/',num2str(length(B.time.epoch))])
        
            if (B.time(i).epochUnix-Tint_era/2)<=B.time(1).epochUnix
                window_start=B.time(1);
            else
                window_start=irf_time(B.time(i).epochUnix-Tint_era/2,'epoch>epochtt');
            end
            if (B.time(i).epochUnix+Tint_era/2)>=B.time(end).epochUnix
                window_end=B.time(end);
            else
                window_end=irf_time(B.time(i).epochUnix+Tint_era/2,'epoch>epochtt');
            end
            
            window_tint=irf.tint(window_start,window_end);
        
            B_window=B.tlim(window_tint);
            Vi_window=Vi.tlim(window_tint);
        
            [~,~,lmn_dir] = irf_minvar(B_window);
        
            ts_B_lmn = irf.ts_vec_xyz(B_window.time,B_window.data*lmn_dir');
            
            ts_V_lmn = irf.ts_vec_xyz(Vi_window.time,Vi_window.data*lmn_dir');
            
            ts_V_lmn=ts_V_lmn.resample(ts_B_lmn);
            
            dB_l_dt = gradient(ts_B_lmn.data(:,1), ts_B_lmn.time.epochUnix);% 用gradient
            dB_m_dt = gradient(ts_B_lmn.data(:,2), ts_B_lmn.time.epochUnix);% 用gradient
            J_m = (1 / mu0) * (dB_l_dt ./ ts_V_lmn.data(:,3)); % 计算J_m
            J_l = - (1 / mu0) * (dB_m_dt ./ ts_V_lmn.data(:,3)); % 计算J_l
            % dB_l_dt=diff(ts_B_lmn.data(:,1)) ./ diff(ts_B_lmn.time.epochUnix);% 用差分
            % J_m = (1 / mu0) * (dB_l_dt ./ ts_V_lmn.data(1:end-1, 3)); % 计算J_m
            
            index=find(ts_B_lmn.time==B.time(i));
            B(i,:)=ts_B_lmn.data(index,:);
            Vi(i,:)=ts_V_lmn.data(index,:);
            jm(i)=J_m(index);
            jl(i)=J_l(index);
        end
        
        ts_jm=TSeries(B.time,jm.*10^-3);
        ts_jl=TSeries(B.time,jl.*10^-3);
    case "single"
        B_window=B.tlim(window_tint);
        Vi_window=Vi.tlim(window_tint);
    
        [~,~,lmn_dir] = irf_minvar(B_window);
    
        ts_B_lmn = irf.ts_vec_xyz(B_window.time,B_window.data*lmn_dir');
        
        ts_V_lmn = irf.ts_vec_xyz(Vi_window.time,Vi_window.data*lmn_dir');
        
        ts_V_lmn=ts_V_lmn.resample(ts_B_lmn);
        
        dB_l_dt = gradient(ts_B_lmn.data(:,1), ts_B_lmn.time.epochUnix);% 用gradient
        dB_m_dt = gradient(ts_B_lmn.data(:,2), ts_B_lmn.time.epochUnix);% 用gradient
        J_m = (1 / mu0) * (dB_l_dt ./ ts_V_lmn.data(:,3)); % 计算J_m
        J_l = - (1 / mu0) * (dB_m_dt ./ ts_V_lmn.data(:,3)); % 计算J_l

        ts_jm=TSeries(B.time,J_m.*10^-3);
        ts_jl=TSeries(B.time,J_l.*10^-3);
end

OUT_jlm.jl=ts_jl;
OUT_jlm.jm=ts_jm;
end