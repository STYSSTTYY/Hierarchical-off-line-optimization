function [Bottom,Top] = Find_The_Row_Position_Of_H(Carrier_i,j,A,S)
% 根据传感器编号估计其在H矩阵中的行的位置
    global Num_Of_Satellite;
    G = A{1,1};
    Sensor_Info = S{1,4};
    temp = 0;
    Bottom = 0;
    Top = 0;
    for i = 1:j
        if G(i,Carrier_i) == 1
            [~,~,~,If_Relative,Dimension,~,~] ...
                 = Extract_Corresponding_Sensor_Info(i,Carrier_i,Sensor_Info);
            if If_Relative
                temp = temp + Dimension;
            else 
                temp = temp + Num_Of_Satellite;
            end
            if i == j
                [~,~,~,If_Relative,Dimension,~,~] ...
                     = Extract_Corresponding_Sensor_Info(i,Carrier_i,Sensor_Info);
                Top = temp;
                if If_Relative
                    Bottom = temp + 1 - Dimension;
                else
                    Bottom = temp + 1 - Num_Of_Satellite;
                end
            end
        end
    end
end