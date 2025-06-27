function X_All = Update_X(X_Carrier_Number_All,Which_Has_Four_Dimension,X_New,Estimations)
% 按状态内储存的格式输出本次解算的状态估计结果
    for j = 1:length(X_Carrier_Number_All)
        [Bottom,Top] = Find_The_Column_Position_Of_H(X_Carrier_Number_All(1,j),X_Carrier_Number_All,Which_Has_Four_Dimension);
        x = X_New(Bottom:Top,1);
        for k = 1:3
            Estimations(k,X_Carrier_Number_All(1,j)) = x(k,1);  % 只记录最新的，因为当前情况下，最新的就是最好的
        end
    end
    X_All = Estimations;
end