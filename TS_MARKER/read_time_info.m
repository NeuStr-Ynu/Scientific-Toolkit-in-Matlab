function [time_info] = read_time_info(file_name)
%READ_TIME_INFO 读取time_info.txt为一个datatime的文件
%   [time_info] = read_time_info()
%% main function
time_info_file = fopen(file_name,'r');

time_info=[];
while ~feof(time_info_file)
    line_str = fgetl(time_info_file);
    time_info_temp = split(line_str,{'.',':',','});
    start_time = datetime([str2double(time_info_temp{1}),str2double(time_info_temp{2}),str2double(time_info_temp{3}), ...
        str2double(time_info_temp{4}),str2double(time_info_temp{5}),str2double([time_info_temp{6},'.',time_info_temp{7}])]);
    end_time = datetime([str2double(time_info_temp{8}),str2double(time_info_temp{9}),str2double(time_info_temp{10}), ...
        str2double(time_info_temp{11}),str2double(time_info_temp{12}),str2double([time_info_temp{13},'.',time_info_temp{14}])]);
    time_info = [time_info; start_time, end_time];
end

end

