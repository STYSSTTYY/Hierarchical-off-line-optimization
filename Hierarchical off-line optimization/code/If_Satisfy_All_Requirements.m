function flag = If_Satisfy_All_Requirements(State,S_Final,P_All)
% 如果已经满足了全部的要求，已经满足了1否0
    flag = 1;
    Estimations = State{1,2};
    Estimations_Requirements = S_Final{1,2};
    [b,a] = size(Estimations_Requirements);
    for i = 1:a  % 检查位置要求是否满足
        Estimations_On_i = The_Estimations_On_Carrier_i(Estimations{1,i});
        if ~isempty(Estimations_On_i)
            Estimations_Numbers = Estimations_On_i(:,1);
            Estimations_Numbers = Estimations_Numbers';
        else
            Estimations_Numbers = [];
        end
        for j = 1:b
            if Estimations_Requirements(j,i) == 1
                if ~ismember(j,Estimations_Numbers)
                    flag = 0;
                    return;
                end
            end
        end
    end
    [Flag2,~] = If_Limit_Not_Satisfaction__Trace(P_All,S_Final);  % 分别检查每个载体上的性能要求是否满足
    if Flag2
        flag = 0;
        return;
    end
    Flag3 = If_Limit_Not_Satisfaction_Trace(P_All,S_Final);  % 分别检查总体性能要求有没有满足
    if Flag3
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