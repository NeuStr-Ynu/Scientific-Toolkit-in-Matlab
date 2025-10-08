function outepochtt=time_rounded(Tint)
% make time fine for saving
% ----------------------------------------------------------
% written by Zipeng Wang with the help of ChatGpt 2025/09/26
% Email: zipengwang023@Gmail.com;
% ----------------------------------------------------------
    t_start=irf_time(Tint(1),'epochtt>vector');
    t_end=irf_time(Tint(2),'epochtt>vector');
    
    dt_start=datetime(t_start(1),t_start(2),t_start(3),t_start(4),t_start(5),t_start(6),'TimeZone','UTC');
    dt_end=datetime(t_end(1),t_end(2),t_end(3),t_end(4),t_end(5),t_end(6),'TimeZone','UTC');
    dt_start.Second=0;
    if dt_end.Second>0
        dt_end=dt_end+minutes(1);
    end
    dt_end.Second=0;
    
    t_start_rounded=datevec(dt_start);
    t_end_rounded=datevec(dt_end);
    
    outepochtt=irf_time([t_start_rounded;t_end_rounded],'vector>epochtt');
end