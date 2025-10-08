function [OutTS] = read_to_ts(db_dir,Tint,data_code)
%GET_TS Read Maven data to Tseries which is available to use in irfu
%   db_dir: your database dir
%   Tint: Time defined by irfu
%   data_code: The specific code for specific data set mostly is in the
%       data file name.
%       now available data code:
%           'mag_l2-sunstate-1sec';
%           'swe_l2_svyspec';
%           'swi_l2_onboardsvyspec';

% ----------------------------------------------------------
% written by Zipeng Wang with the help of ChatGpt 2025/03/29
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------
% switch data_code
switch data_code
    case 'mag_l2-sunstate-1sec'
        data_type='line';
        data_virable='OB_B';
    case 'swe_l2_svyspec'
        data_type='spec';
        data_virable='diff_en_fluxes';
        flag_virable='energy';
    case 'swi_l2_onboardsvyspec'
        data_type='spec';
        data_virable='spectra_diff_en_fluxes';
        flag_virable='energy_spectra';
end

% get the file_list in database
[file_list] = read_data_file(db_dir,Tint,data_code);

% read the file using the function 'get_ts'
TScell = cell(length(file_list),1);
for i = 1:length(file_list)
    TScell{i} = get_ts(dataobj(file_list{i}), data_virable);
end

% Tseries combine
OutTS=TScell{1};
if length(TScell)>=2
    for i = 2:length(TScell)
        OutTS=combine(OutTS,TScell{i});
    end
end

switch data_type
    case 'line'
        OutTS=OutTS.tlim(Tint);% for mag
    case 'spec'
        En = cdfread(file_list{1}, 'Variable', flag_virable);% ion
        OutTS=OutTS.tlim(Tint);
        out.f_unit='eV';% 不写会换成k这个量级
        out.f=En{1};% for pad
        out.p=OutTS.data;
        out.t=OutTS.time.epochUnix;
        out.p_label=OutTS.units;
        OutTS=out;
end
end
