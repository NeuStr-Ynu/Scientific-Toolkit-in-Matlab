function [OutTS] = read_insitu_data(db_dir,Tint,data_virable)
%READ_INSITU_DATA read maven insitu data to Tseries
% data_virable including:(from KIMI kimi.com)
    % 时间轴变量
    % epoch: 时间戳，记录数据的时间点。
    % 电子密度相关变量
    % LPW_Electron_density: 电子密度（LPW仪器）。
    % LPW_Electron_density_min: 电子密度最小值（LPW仪器）。
    % LPW_Electron_density_max: 电子密度最大值（LPW仪器）。
    % SWEA_Electron_density: 电子密度（SWEA仪器）。
    % SWEA_Electron_density_quality: 电子密度数据质量（SWEA仪器）。
    % 电子温度相关变量
    % LPW_Electron_temperature: 电子温度（LPW仪器）。
    % LPW_Electron_temperature_min: 电子温度最小值（LPW仪器）。
    % LPW_Electron_temperature_max: 电子温度最大值（LPW仪器）。
    % SWEA_Electron_temperature: 电子温度（SWEA仪器）。
    % SWEA_Electron_temperature_quality: 电子温度数据质量（SWEA仪器）。
    % 航天器电位相关变量
    % LPW_Spacecraft_potential: 航天器电位（LPW仪器）。
    % LPW_Spacecraft_potential_min: 航天器电位最小值（LPW仪器）。
    % LPW_Spacecraft_potential_max: 航天器电位最大值（LPW仪器）。
    % 电场波功率相关变量
    % LPW_E_field_wave_power_2_100: 2-100 Hz电场波功率（LPW仪器）。
    % LPW_E_field_wave_power_2_100_data_quality: 2-100 Hz电场波功率数据质量（LPW仪器）。
    % LPW_E_field_wave_power_100_800: 100-800 Hz电场波功率（LPW仪器）。
    % LPW_E_field_wave_power_100_800_data_quality: 100-800 Hz电场波功率数据质量（LPW仪器）。
    % LPW_E_field_wave_power_800_1000: 800-1000 Hz电场波功率（LPW仪器）。
    % LPW_E_field_wave_power_800_1000_data_quality: 800-1000
    % Hz电场波功率数据质量（LPW仪器）。 
    % EUV辐射相关变量
    % LPW_EUV_irradiance_pt1_7: 0.1-7.0 nm波段的EUV辐射（LPW-EUV仪器）。
    % LPW_EUV_irradiance_pt1_7_data_quality: 0.1-7.0 nm波段的EUV辐射数据质量（LPW-EUV仪器）。
    % LPW_EUV_irradiance_17_22: 17-22 nm波段的EUV辐射（LPW-EUV仪器）。
    % LPW_EUV_irradiance_17_22_data_quality: 17-22 nm波段的EUV辐射数据质量（LPW-EUV仪器）。
    % LPW_EUV_irradiance_lyman_alpha: Lyman-alpha波段的EUV辐射（LPW-EUV仪器）。
    % LPW_EUV_irradiance_lyman_alpha_data_quality: Lyman-alpha波段的EUV辐射数据质量（LPW-EUV仪器）。
    % 离子密度相关变量
    % SWIA_Hplus_density: 氢离子密度（SWIA仪器）。
    % SWIA_Hplus_density_data_quality: 氢离子密度数据质量（SWIA仪器）。
    % STATIC_Hplus_density: 氢离子密度（STATIC仪器）。
    % STATIC_Hplus_density_data_quality: 氢离子密度数据质量（STATIC仪器）。
    % STATIC_Oplus_density: 氧离子密度（STATIC仪器）。
    % STATIC_Oplus_density_data_quality: 氧离子密度数据质量（STATIC仪器）。
    % STATIC_O2plus_density: 氧分子离子密度（STATIC仪器）。
    % STATIC_O2plus_density_data_quality: 氧分子离子密度数据质量（STATIC仪器）。
    % 离子温度相关变量
    % STATIC_Hplus_temperature: 氢离子温度（STATIC仪器）。
    % STATIC_Hplus_temperature_data_quality: 氢离子温度数据质量（STATIC仪器）。
    % STATIC_Oplus_temperature: 氧离子温度（STATIC仪器）。
    % STATIC_Oplus_temperature_data_quality: 氧离子温度数据质量（STATIC仪器）。
    % STATIC_O2plus_temperature: 氧分子离子温度（STATIC仪器）。
    % STATIC_O2plus_temperature_data_quality: 氧分子离子温度数据质量（STATIC仪器）。
    % 离子流速相关变量
    % SWIA_Hplus_flow_velocity_MSO: 氢离子流速（MSO坐标系，SWIA仪器）。
    % SWIA_Hplus_flow_velocity_MSO_data_quality: 氢离子流速数据质量（MSO坐标系，SWIA仪器）。
    % STATIC_O2plus_flow_velocity_MAVEN_APP: 氧分子离子流速（MAVEN_APP坐标系，STATIC仪器）。
    % STATIC_O2plus_flow_velocity_MAVEN_APP_data_quality: 氧分子离子流速数据质量（MAVEN_APP坐标系，STATIC仪器）。
    % STATIC_O2plus_flow_velocity_MSO: 氧分子离子流速（MSO坐标系，STATIC仪器）。
    % STATIC_O2plus_flow_velocity_MSO_data_quality: 氧分子离子流速数据质量（MSO坐标系，STATIC仪器）。
    % 离子能量通量相关变量
    % SEP_Ion_Energy_Flux_30_1000_FOV_1F: 30-1000 keV离子能量通量（FOV 1-F，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_1F_data_quality: 30-1000 keV离子能量通量数据质量（FOV 1-F，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_1R: 30-1000 keV离子能量通量（FOV 1-R，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_1R_data_quality: 30-1000 keV离子能量通量数据质量（FOV 1-R，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_2F: 30-1000 keV离子能量通量（FOV 2-F，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_2F_data_quality: 30-1000 keV离子能量通量数据质量（FOV 2-F，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_2R: 30-1000 keV离子能量通量（FOV 2-R，SEP仪器）。
    % SEP_Ion_Energy_Flux_30_1000_FOV_2R_data_quality: 30-1000 keV离子能量通量数据质量（FOV 2-R，SEP仪器）。
    % 电子能量通量相关变量
    % SEP_Electron_Energy_Flux_30_300_FOV_1F: 30-300 keV电子能量通量（FOV 1-F，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_1F_data_quality: 30-300 keV电子能量通量数据质量（FOV 1-F，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_1R: 30-300 keV电子能量通量（FOV 1-R，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_1R_data_quality: 30-300 keV电子能量通量数据质量（FOV 1-R，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_2F: 30-300 keV电子能量通量（FOV 2-F，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_2F_data_quality: 30-300 keV电子能量通量数据质量（FOV 2-F，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_2R: 30-300 keV电子能量通量（FOV 2-R，SEP仪器）。
    % SEP_Electron_Energy_Flux_30_300_FOV_2R_data_quality: 30-300 keV电子能量通量数据质量（FOV 2-R，SEP仪器）。
    % 磁场相关变量
    % MAG_field_MSO: 磁场向量（MSO坐标系，MAG仪器）。
    % MAG_field_MSO_data_quality: 磁场向量数据质量（MSO坐标系，MAG仪器）。
    % MAG_field_GEO: 磁场向量（GEO坐标系，MAG仪器）。
    % MAG_field_GEO_data_quality: 磁场向量数据质量（GEO坐标系，MAG仪器）。
    % MAG_field_RMS_deviation: 磁场均方根偏差（MAG仪器）。
    % MAG_field_RMS_deviation_data_quality: 磁场均方根偏差数据质量（MAG仪器）。
    % 中性气体密度相关变量
    % NGIMS_He_density: 氦密度（NGIMS仪器）。
    % NGIMS_He_density_precision: 氦密度精度（NGIMS仪器）。
    % NGIMS_He_density_data_quality: 氦密度数据质量（NGIMS仪器）。
    % NGIMS_O_density: 氧密度（NGIMS仪器）。
    % NGIMS_O_density_precision: 氧密度精度（NGIMS仪器）。
    % NGIMS_O_density_data_quality: 氧密度数据质量（NGIMS仪器）。
    % NGIMS_CO_density: 一氧化碳密度（NGIMS仪器）。
    % NGIMS_CO_density_precision: 一氧化碳密度精度（NGIMS仪器）。
    % NGIMS_CO_density_data_quality: 一氧化碳密度数据质量（NGIMS仪器）。
    % NGIMS_N2_density: 氮气密度（NGIMS仪器）。
    % NGIMS_N2_density_precision: 氮气密度精度（NGIMS仪器）。
    % NGIMS_N2_density_data_quality: 氮气密度数据质量（NGIMS仪器）。
    % NGIMS_NO_density: 一氧化氮密度（NGIMS仪器）。
    % NGIMS_NO_density_precision: 一氧化氮密度精度（NGIMS仪器）。
    % NGIMS_NO_density_data_quality: 一氧化氮密度数据质量（NGIMS仪器）。
    % NGIMS_Ar_density: 氩密度（NGIMS仪器）。
    % NGIMS_Ar_density_precision: 氩密度精度（NGIMS仪器）。
    % NGIMS_Ar_density_data_quality: 氩密度数据质量（NGIMS仪器）。
    % NGIMS_CO2_density: 二氧化碳密度（NGIMS仪器）。
    % NGIMS_CO2_density_precision: 二氧化碳密度精度（NGIMS仪器）。
    % NGIMS_CO2_density_data_quality: 二氧化碳密度数据质量（NGIMS仪器）。
    % 离子密度（amu）相关变量
    % NGIMS_Ion_density_32plus: 质量数为32的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_32plus: 质量数为32的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_32plus: 质量数为32的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_44plus: 质量数为44的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_44plus: 质量数为44的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_44plus: 质量数为44的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_30plus: 质量数为30的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_30plus: 质量数为30的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_30plus: 质量数为30的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_16plus: 质量数为16的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_16plus: 质量数为16的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_16plus: 质量数为16的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_28plus: 质量数为28的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_28plus: 质量数为28的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_28plus: 质量数为28的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_12plus: 质量数为12的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_12plus: 质量数为12的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_12plus: 质量数为12的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_17plus: 质量数为17的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_17plus: 质量数为17的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_17plus: 质量数为17的离子密度数据质量（NGIMS仪器）。
    % NGIMS_Ion_density_14plus: 质量数为14的离子密度（NGIMS仪器）。
    % NGIMS_Ion_density_precision_14plus: 质量数为14的离子密度精度（NGIMS仪器）。
    % NGIMS_Ion_density_data_quality_14plus: 质量数为14的离子密度数据质量（NGIMS仪器）。
    % 航天器位置和姿态相关变量
    % SPICE_spacecraft_GEO: 航天器位置（GEO坐标系）。
    % SPICE_spacecraft_MSO: 航天器位置（MSO坐标系）。
    % SPICE_spacecraft_longitude_GEO: 航天器经度（GEO坐标系）。
    % SPICE_spacecraft_latitude_GEO: 航天器纬度（GEO坐标系）。
    % SPICE_spacecraft_sza: 航天器太阳天顶角。
    % SPICE_spacecraft_local_time: 航天器当地时间。
    % SPICE_spacecraft_altitude: 航天器高度。
    % SPICE_spacecraft_attitude_GEO: 航天器姿态（GEO坐标系）。
    % SPICE_spacecraft_attitude_MSO: 航天器姿态（MSO坐标系）。
    % SPICE_app_attitude_GEO: 航天器有效载荷平台姿态（GEO坐标系）。
    % SPICE_app_attitude_MSO: 航天器有效载荷平台姿态（MSO坐标系）。
    % 轨道和太阳相关变量
    % SPICE_Orbit_Number: 轨道编号。
    % Inbound_Outbound_Flag: 进入/离开标志。
    % SPICE_Mars_season: 火星季节（太阳经度Ls）。
    % SPICE_Mars_Sun_distance: 火星-太阳距离。
    % SPICE_Subsolar_Point_longitude_GEO: 子太阳点经度（GEO坐标系）。
    % SPICE_Subsolar_Point_latitude_GEO: 子太阳点纬度（GEO坐标系）。
    % SPICE_Sub_Mars_Point_longitude: 子火星点经度。
    % SPICE_Sub_Mars_Point_latitude: 子火星点纬度。
    % 旋转矩阵变量
    % Rotation_matrix_IAU_MARS_MAVEN_MSO: 从IAU_MARS坐标系到MAVEN_MSO坐标系的旋转矩阵。
    % Rotation_matrix_SPACECRAFT_MAVEN_MSO: 从MAVEN_SPACECRAFT坐标系到MAVEN_MSO坐标系的旋转矩阵。
% ----------------------------------------------------------
% written by Zipeng Wang 2025/06/05
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------

% get the file_list in database
[file_list] = read_data_file(db_dir,Tint,'insitu_kp-4sec');

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
OutTS=OutTS.tlim(Tint);

end

