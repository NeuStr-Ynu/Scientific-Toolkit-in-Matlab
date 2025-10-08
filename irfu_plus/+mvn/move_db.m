function []=move_db(source_root,target_root)
% [MVN]  []=mvn_move_db(source root,target root)
% move your download data to database whice our code can use

% ----------------------------------------------------------
% written by Zipeng Wang with the help of ChatGpt 2025/03/29
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------

% read all file
file_list = dir(fullfile(source_root, '**', '*.cdf'));

for i = 1:length(file_list)
    source_file = fullfile(file_list(i).folder, file_list(i).name);
    tokens = strsplit(file_list(i).name, '_');

    if length(tokens) < 5
        fprintf('%s is not accessible\n', file_list(i).name);
        continue;
    end

    instrument = tokens{2}; % 获取仪器名

    % 自动合并 data_type，直到遇到日期部分 (YYYYMMDD)
    data_type = tokens{3};
    j = 4;
    while j <= length(tokens) && ~contains(tokens{j}, '20')  % 找到 YYYYMMDD
        data_type = strcat(data_type, '_', tokens{j});
        j = j + 1;
    end

    % 识别日期
    date_str = tokens{j};
    year_str = date_str(1:4);
    month_str = date_str(5:6);

    % 创建目标路径
    target_folder = fullfile(target_root, instrument, data_type, year_str, month_str);
    if ~exist(target_folder, 'dir')
        mkdir(target_folder);
    end

    % 移动文件
    target_file = fullfile(target_folder, file_list(i).name);
    movefile(source_file, target_file);
    fprintf('Move: %s -> %s\n', source_file, target_file);
end

disp('move data finished!!!!');

end
