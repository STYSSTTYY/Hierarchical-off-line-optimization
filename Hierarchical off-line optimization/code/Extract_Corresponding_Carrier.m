function [Sender_Carrier,Receivor_Carrier,Object] = Extract_Corresponding_Carrier(Row,Column,Num)
% 根据状态估计传输矩阵提取出状态估计的收发载体
% 输出内容
% Sender_Carrier,Receivor_Carrier,Object
    temp1 = 0;
    for i = 1:Num
        temp1 = temp1 + Num;
        if (temp1>Row) || (temp1==Row)
            Sender_Carrier = i;
            Object = Row - Sender_Carrier*Num + Num;
            break;
        end
    end
    Receivor_Carrier = Column;
end