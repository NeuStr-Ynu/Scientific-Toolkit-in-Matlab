function [OutTS] = read_to_ts(db_dir,Tint,data_code,var)
%GET_TS Read Wind data to Tseries which is available to use in irfu
%   db_dir: your database dir
%   Tint: Time defined by irfu
%   data_code: The specific code for specific data set mostly is in the
%       data file name.
%       now available data code:
%           'h0_mfi';
%           'h2_mfi';
%           'h3_mfi';
%           'h4_mfi';
%   var: The variable in data file
%       now available variable:
%           'BGSM';     1 min magnetic field
%           'BGSE';     1 min magnetic field
%           'B3GSM';    3 sec magnetic field
%           'B3GSE';    3 sec magnetic field
%           'PGSM';     1 min position vector
%           'PGSE';     1 min position vector

% ----------------------------------------------------------
% written by Zipeng Wang with the help of ChatGpt 2025/09/24
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------

% get the file_list in database
[file_list] = read_data_file(db_dir,Tint,data_code);

% read the file using the function 'get_ts'
TScell = cell(length(file_list),1);
for i = 1:length(file_list)
    TScell{i} = get_ts(dataobj(file_list{i}), var);
end

% Tseries combine
OutTS=TScell{1};
if length(TScell)>=2
    for i = 2:length(TScell)
        OutTS=combine(OutTS,TScell{i});
    end
end
OutTS=OutTS.tlim(Tint);% for mag

end
