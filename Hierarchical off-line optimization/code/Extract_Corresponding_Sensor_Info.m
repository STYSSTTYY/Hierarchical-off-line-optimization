function [Sender_Carrier,Receivor_Carrier,The_Num_of_Sensor,If_Relative,Dimension,Sig_Square,Object] ...
    = Extract_Corresponding_Sensor_Info(Row,Column,Sensor_Info)
% 根据传感器观测传输矩阵从传感器信息中提取相应的传感器信息
% 输出内容
% Sender_Carrier,Receivor_Carrier,The_Num_of_Sensor,If_Relative,Dimension,Sig_Square,Object
    m = length(Sensor_Info);
    temp1 = 0;
    for i = 1:m
        [temp2,~] = size(Sensor_Info{i,1}{1,2});
        temp1 = temp1 + temp2;
        if (temp1 > Row) || (temp1 == Row)
            break;
        end
    end
    Sender_Carrier = i;
    Receivor_Carrier = Column;
    The_Num_of_Sensor = Row - (temp1 - temp2);
    Info = Sensor_Info{Sender_Carrier,1}{1,2}(The_Num_of_Sensor,:);
    If_Relative = Info(1,1);  % 是相对观测的话为1，否则为0
    Dimension = Info(1,2);
    Sig_Square = Info(1,3);
    Object = Info(1,4);
end