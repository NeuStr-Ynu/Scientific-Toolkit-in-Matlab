function [lon1, lat, lon2] = calc_terminator(subsolar_lon, subsolar_lat)
%CALC_TERMINATOR  Calculate planetary terminator (sunrise and sunset) coordinates.
%
% This function calculates the geographic coordinates of the two planetary terminator lines,
% where the solar zenith angle equals 90 degrees (the boundary between sunlight and shadow),
% based on the subsolar point's longitude and latitude.
%
% INPUTS:
%   subsolar_lon : Longitude of the subsolar point (degrees), range [0, 360]
%   subsolar_lat : Latitude of the subsolar point (degrees), range [-90, 90]
%
% OUTPUTS:
%   lon1 : Longitude array of one terminator line (degrees), range [0, 360]
%   lat  : Corresponding latitude array for both terminator lines (degrees), range [-90, 90]
%   lon2 : Longitude array of the opposite terminator line (degrees), range [0, 360]
%
% Notes:
%   - The calculation assumes a spherical planetary surface.
%   - Trigonometric functions and degree-radian conversions are used.
%   - The two output lines represent the morning and evening terminators, located on opposite sides of the subsolar point.
% ----------------------------------------------------------
% written by Zipeng Wang with the help of ·ChatGpt 2025/06/05
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------


    % 输入经纬度，单位度
    phi_s = deg2rad(subsolar_lat);
    lambda_s = deg2rad(subsolar_lon);

    lat_all = linspace(-90, 90, 500);
    phi_all = deg2rad(lat_all);

    val = -tan(phi_all) .* tan(phi_s);

    % 只保留abs(val)<=1的点，其他点丢弃
    valid_idx = abs(val) <= 1;

    lat = lat_all(valid_idx);
    val_valid = val(valid_idx);

    delta_lambda = acos(val_valid);

    lon1 = mod(rad2deg(lambda_s + delta_lambda), 360);
    lon2 = mod(rad2deg(lambda_s - delta_lambda), 360);
end
