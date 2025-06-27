function flag = If_Satisfy_Performance_And_Costs(State,S_Final,P_All)
% 如果已经满足了性能要求和代价要求，已经满足了1否0
    flag = 1;
    Flag2 = If_Limit_Not_Satisfaction_Trace(P_All,S_Final);  % 检查性能要求是否满足
    if Flag2
        flag = 0;
        return;
    end
    Cal = State{1,3}{1,1};
    Com = State{1,3}{1,2};
    if ~If_Cost_Meets(Cal,Com,S_Final)
        flag = 0;
        return;
    end
end