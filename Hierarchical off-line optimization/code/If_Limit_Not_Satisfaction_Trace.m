function flag = If_Limit_Not_Satisfaction_Trace(P_Upper_Limit,S_Final)
% 检查性能上限能否满足性能要求,暂时只比较状态估计的方差,互协方差先不管
%   1是性能上限不满足，0是满足
    if isempty(P_Upper_Limit)
        flag = 1;
        return;
    end
    P = S_Final{1,1};
    Num = length(P_Upper_Limit);
    
    P_Upper_Limit_ = Sort_Out_Best_from_all_P_Trace(P_Upper_Limit);  
                                                               
    for i = 1:Num
        P_Now = P_Upper_Limit_((i-1)*3+1:i*3,(i-1)*3+1:i*3);
        P_Tar = P((i-1)*3+1:i*3,(i-1)*3+1:i*3);
        if isnan(trace(P_Tar))
            flag = 0;
        elseif ~isnan(trace(P_Now))
            if (trace(P_Now) > trace(P_Tar))
                flag = 1;
                return;
            else
                flag = 0;
            end
        else
            flag = 1;
            return;
        end
    end
end