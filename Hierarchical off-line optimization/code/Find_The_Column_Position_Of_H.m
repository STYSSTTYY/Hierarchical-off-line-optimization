function [Bottom,Top] = Find_The_Column_Position_Of_H(Carrier_Number,X_Carrier_Number_All,Which_Has_Four_Dimension)
% 根据载体编号估计其在H矩阵中的位置
    temp1 = 0;
    flag = 0;
    for i = 1:length(X_Carrier_Number_All)
        for j = 1:length(Which_Has_Four_Dimension)
            if Which_Has_Four_Dimension(1,j) == X_Carrier_Number_All(1,i)
                flag = 1;
            end
        end
        if flag
            temp1 = temp1 +4;
        else
            temp1 = temp1 +3;
        end
        if X_Carrier_Number_All(1,i) == Carrier_Number
            Top = temp1;
            Bottom = temp1 - 2 - flag;
        end
        flag = 0;
    end
end