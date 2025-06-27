function P_All = Update_P(X_Carrier_Number_All,Which_Has_Four_Dimension,S_,P)
% 按状态内储存的格式输出本次解算的协方差结果
    
    for j = 1:length(X_Carrier_Number_All)
        [Bottom,Top] = Find_The_Column_Position_Of_H(X_Carrier_Number_All(1,j),X_Carrier_Number_All,Which_Has_Four_Dimension);
        for jj = 1:length(X_Carrier_Number_All)
            [Bottom2,Top2] = Find_The_Column_Position_Of_H(X_Carrier_Number_All(1,jj),X_Carrier_Number_All,Which_Has_Four_Dimension);
            x = S_(Bottom:Top,Bottom2:Top2);
            for k = 1:3
                for kk = 1:3
                    P((X_Carrier_Number_All(1,j)-1)*3+k,(X_Carrier_Number_All(1,jj)-1)*3+kk) = x(k,kk);  % 只记录最新的，因为当前情况下，最新的就是最好的
                end
            end
        end
    end
    P_All = P;
end