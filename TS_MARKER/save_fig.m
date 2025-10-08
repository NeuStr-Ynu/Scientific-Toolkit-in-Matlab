function save_fig(fig, res_dir, mission_code, i, fig_code, Tint)
%SAVE_FIG_WITH_TIME Save figure with mission, index, code, and time range
%
%   INPUTS:
%     fig          - Figure handle
%     res_dir      - Base directory to save
%     mission_code - Mission name/code (string)
%     i            - Index number (integer)
%     fig_code     - Figure code (string) 
%                       To ensure compatibility with the TS_mark function,
%                        please ensure this part follows a format similar to ov-2hr.
%     Tint         - irf.tint object specifying the time interval
%
%   OUTPUT:
%     filename     - Full path of the saved figure
% ----------------------------------------------------------
% written by Zipeng Wang with the help of ChatGpt 2025/09/26
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------
target_dir = fullfile(res_dir, mission_code);

if ~exist(target_dir, 'dir')
    mkdir(target_dir);
    fprintf('Directory does not exist. Created: %s\n', target_dir);
else
    fprintf('Directory already exists: %s\n', target_dir);
end

t_start_str=irf_time(Tint(1),'epochtt>utc_yyyy-mm-dd_HHMM');
t_end_str=irf_time(Tint(2),'epochtt>utc_yyyy-mm-dd_HHMM');
filename = fullfile(res_dir, mission_code, ...
    [mission_code,'_NO_', num2str(i), '_', fig_code, '_', ...
    t_start_str, '-', t_end_str, '.png']);
exportgraphics(fig, filename)
end