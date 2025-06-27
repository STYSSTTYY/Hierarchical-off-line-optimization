function [Bottom,Top] = Find_The_Row_Position_Of_H___(Carrier_i,j,A,S,Num_Of_Satellite)
% 根据载体编号估计其在H矩阵中的行的位置
    [m,~] = size(A{1,1});
    G = A{1,1};
    A_Estimation_Trans = A{1,2};
    Sensor_Info = S{1,4};
    temp = 0;
    Bottom = 0;
    Top = 0;
    for i = 1:m
        if G(i,Carrier_i) == 1
            [~,~,~,If_Relative,Dimension,~,~] ...
                 = Extract_Corresponding_Sensor_Info(i,Carrier_i,Sensor_Info);
            if If_Relative
                temp = temp + Dimension;
            else 
                temp = temp + Num_Of_Satellite;
            end
        end
    end
    for i = 1:j
        if A_Estimation_Trans(i,Carrier_i)==1
            temp = temp+3;
            if i == j
                Top = temp;
                Bottom = temp - 2;
            end
        end
    end
end