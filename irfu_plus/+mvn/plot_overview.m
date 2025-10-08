function plot_overview(time_range,db_dir)
%PLOT_OVERVIEW plot overview figure
%   

OutTS_i=mvn.read_to_ts(db_dir,time_range,'swi_l2_onboardsvyspec');
OutTS_e=mvn.read_to_ts(db_dir,time_range,'swe_l2_svyspec');
OutTS_mag=mvn.read_to_ts(db_dir,time_range,'mag_l2-sunstate-1sec');
OutTS_ne=mvn.read_insitu_data(db_dir,time_range,'SWEA_Electron_density');
OutTS_ni=mvn.read_insitu_data(db_dir,time_range,'SWIA_Hplus_density');
OutTS_Vi=mvn.read_insitu_data(db_dir,time_range,'SWIA_Hplus_flow_velocity_MSO');
% 这是从sunstate坐标系转换到mso坐标系的旋转矩阵(sunstate与mso坐标系有差别)
theta = deg2rad(25.19);
R = [1, 0, 0; ...
     0, cos(theta), -sin(theta); ...
     0, sin(theta), cos(theta)];
OutTS_mag=irf.ts_vec_xyz(OutTS_mag.time,OutTS_mag.data*R');

[h1,h2] = initialize_combined_plot('leftright',5,2,1,2,'horizontal');
figpos=[81          60        1561         900];
set(gcf, 'Position', figpos); % 设置图形窗口位置和大小
hcb=[];
% =======================================
% ================卫星数据================
pn=0;
pn=pn+1;
irf_plot(h1(pn),OutTS_ne);
% irf_plot(h1(pn),OutTS_ne,'o','MarkerSize', 3);
hold(h1(pn),'on')
irf_plot(h1(pn),OutTS_ni);
% irf_plot(h1(pn),OutTS_ni,'o','MarkerSize', 3);
irf_legend(h1(pn),{'Ne';'Ni'},[1.02, 0.75])
yl(pn)=ylabel(h1(pn),{'N (SWEA/SWIA)','[$cm^{-3}$]'},'Interpreter','latex');

pn=pn+1;
irf_plot(h1(pn),OutTS_Vi);
hold(h1(pn),'on')
irf_legend(h1(pn),{'Vx';'Vy';'Vz'},[1.02, 0.75])
yl(pn)=ylabel(h1(pn),{'Vi (SWIA)','[$m/s$]'},'Interpreter','latex');

pn=pn+1;
irf_plot(h1(pn),OutTS_mag);
hold(h1(pn),'on')
irf_plot(h1(pn),OutTS_mag.abs);
irf_legend(h1(pn),{'B_X';'B_Y';'B_Z';'B'},[1.02, 0.85])
yl(pn)=ylabel(h1(pn),{'B','[$nT$]'},'Interpreter','latex');

pn=pn+1;
[h1(pn),hcb(pn)]=irf_spectrogram(h1(pn),OutTS_e,'log');
colormap(h1(pn),"jet")
set(h1(pn),'YScale','log')
yl(pn)=ylabel(h1(pn),{'electron energy','[$eV$]'},'Interpreter','latex');

pn=pn+1;
[h1(pn),hcb(pn)]=irf_spectrogram(h1(pn),OutTS_i,'log');
colormap(h1(pn),"jet")
set(h1(pn),'YScale','log')
yl(pn)=ylabel(h1(pn),{'ion energy','[$eV$]'},'Interpreter','latex');

plot_to_great(time_range,h1,hcb,[132          86        1547         838])

% =======================================
% ================卫星轨迹================
R = mvn.read_insitu_data(db_dir, time_range, 'SPICE_spacecraft_MSO');
trace = R.data;
time = R.time;
Rm = 3390; % Mars radius (km)
theta = linspace(0, 2*pi, 500);

% === Model parameters (Vignes et al., 2000, Direct Fit method) ===
% Bow Shock parameters
X0_bs = 0.64 * Rm;
eps_bs = 1.03;
L_bs = 2.04 * Rm;
alpha_bs = deg2rad(4);

% MPB parameters
X0_mpb = 0.78 * Rm;
eps_mpb = 0.90;
L_mpb = 0.96 * Rm;
alpha_mpb = deg2rad(4);

% Calculate Bow Shock boundary
r_bs = L_bs ./ (1 + eps_bs * cos(theta));
x_bs = r_bs .* cos(theta) + X0_bs;
z_bs = r_bs .* sin(theta);
x_bs_rot = x_bs * cos(alpha_bs) + z_bs * sin(alpha_bs);
z_bs_rot = -x_bs * sin(alpha_bs) + z_bs * cos(alpha_bs);

% Calculate MPB boundary
r_mpb = L_mpb ./ (1 + eps_mpb * cos(theta));
x_mpb = r_mpb .* cos(theta) + X0_mpb;
z_mpb = r_mpb .* sin(theta);
x_mpb_rot = x_mpb * cos(alpha_mpb) + z_mpb * sin(alpha_mpb);
z_mpb_rot = -x_mpb * sin(alpha_mpb) + z_mpb * cos(alpha_mpb);

% Determine which points are inside Mars (radius < Rm)
r_trace = sqrt(trace(:,1).^2 + trace(:,3).^2);
inside_mars = r_trace <= Rm;

% ==== XZ Plane ====
hold(h2(1),"on"); axis(h2(1),"equal"); grid(h2(1),"off");
title(h2(1),'MSO XZ Plane');
xlabel(h2(1),'X (km)'); ylabel(h2(1),'Z (km)');
xlim(h2(1),[-10000, 10000]); ylim(h2(1),[-10000, 10000]);

% Plot Bow Shock and MPB
plot(h2(1),x_bs_rot, z_bs_rot, 'r', 'LineWidth', 1.5, 'DisplayName', 'Bow Shock');
plot(h2(1),x_mpb_rot, z_mpb_rot, 'b', 'LineWidth', 1.5, 'DisplayName', 'MPB');

% Plot Mars
for x = -Rm:10:Rm
    z = sqrt(Rm^2 - x^2);
    col = 'k'; if x > 0, col = [0.8, 0.4, 0.3]; end
    plot(h2(1),[x x], [-z z], '-', 'Color', col, 'HandleVisibility', 'off');
end

% Plot trajectory as scatter points
scatter(h2(1),trace(~inside_mars,1), trace(~inside_mars,3), 5, 'k', 'filled', 'HandleVisibility', 'off'); % Outside Mars
scatter(h2(1),trace(inside_mars,1), trace(inside_mars,3), 5, 'w', 'filled', 'HandleVisibility', 'off'); % Inside Mars

% Label trajectory
mid_idx = ceil(size(trace,1)/2); % Middle point for label placement
text(h2(1),trace(mid_idx,1) + 500, trace(mid_idx,3), 'Spacecraft Trajectory', 'Color', 'k', 'FontSize', 10);

% Mark start and end points with times
scatter(h2(1),trace(1,1), trace(1,3), 10, 'g', 'filled', 'DisplayName', 'Start');
scatter(h2(1),trace(end,1), trace(end,3), 10, 'r', 'filled', 'DisplayName', 'End');
start_time = irf_time(time(1), 'epochtt>utc_HH:MM');
end_time = irf_time(time(end), 'epochtt>utc_HH:MM');
text(h2(1),trace(1,1) + 500, trace(1,3), sprintf('%s', start_time),'Color','r');
text(h2(1),trace(end,1) + 500, trace(end,3), sprintf('%s', end_time),'Color','g');

legend(h2(1),'off');

% ==== XY Plane ====
hold(h2(2),"on"); axis(h2(2),"equal"); grid(h2(2),"off");
title(h2(2),'MSO YZ Plane');
xlabel(h2(2),'Y (km)'); ylabel(h2(2),'Z (km)');
xlim(h2(2),[-10000, 10000]); ylim(h2(2),[-10000, 10000]);

% Plot Bow Shock and MPB
plot(h2(2),x_bs_rot, z_bs_rot, 'r', 'LineWidth', 1.5, 'DisplayName', 'Bow Shock');
plot(h2(2),x_mpb_rot, z_mpb_rot, 'b', 'LineWidth', 1.5, 'DisplayName', 'MPB');

% Plot Mars
theta_circ = linspace(0, 2*pi, 300);
y_circ = Rm * cos(theta_circ);
z_circ = Rm * sin(theta_circ);
fill(h2(2),y_circ, z_circ, [0.8, 0.4, 0.3], 'DisplayName', 'Mars');
fill(h2(2),y_circ(y_circ<0), z_circ(y_circ<0), 'k', 'HandleVisibility', 'off');

% Determine which points are inside Mars (radius < Rm)
r_trace = sqrt(trace(:,1).^2 + trace(:,2).^2);
inside_mars = r_trace <= Rm;

% Plot trajectory as scatter points
scatter(h2(2),trace(~inside_mars,1), trace(~inside_mars,2), 5, 'k', 'filled', 'HandleVisibility', 'off'); % Outside Mars
scatter(h2(2),trace(inside_mars,1), trace(inside_mars,2), 5, 'w', 'filled', 'HandleVisibility', 'off'); % Inside Mars

% Label trajectory
text(h2(2),trace(mid_idx,1) + 500, trace(mid_idx,2), 'Spacecraft Trajectory', 'Color', 'k', 'FontSize', 10);

% Mark start and end points with times
scatter(h2(2),trace(1,1), trace(1,2), 10, 'g', 'filled', 'DisplayName', 'Start');
scatter(h2(2),trace(end,1), trace(end,2), 10, 'r', 'filled', 'DisplayName', 'End');
text(h2(2),trace(1,1) + 500, trace(1,2), sprintf('%s', start_time),'Color','r');
text(h2(2),trace(end,1) + 500, trace(end,2), sprintf('%s', end_time),'Color','g');
legend(h2(2),'off');
end