function X_Temp = Get_Estimations_Last_Step_Est(Est,Num,X,State)
    [mm,m] = size(X);
    X_Temp = zeros(mm,m);
    Estimations = State{1,2};
    Estimations_On_i = {};  % 确定当前每个载体上到底有哪些状态估计
    for k = 1:m
        temp = The_Estimations_On_Carrier_i(Estimations{1,k});
        if isempty(temp)
            temp = [];
        else
            temp = temp(:,1);
            temp = temp';
        end
        Estimations_On_i(end+1,:) = {temp};
    end
    for i = 1:Num
        if (~isempty(Estimations_On_i{i,1}))&&ismember(i,Est)
            for j = 1:length(Estimations_On_i{i,1})
                Carrier_Number = i;
                Estimation_Number = Estimations_On_i{i,1}(1,j);
                q = (Carrier_Number-1)*Num + Estimation_Number;
                for k = 1:Num
                    if k == Carrier_Number
                        X_Temp(q,k) = 1;  % 自己载体上的状态估计是必须要用的，标记为1
                    end
                end
            end
        end
    end
end