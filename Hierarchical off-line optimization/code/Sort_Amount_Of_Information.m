function Sequence = Sort_Amount_Of_Information(i,Who_Can,G_Temp,State)
% 将所有可以解算的载体上的信息按照目前不存在但是要求存在的载体i的状态估计的信息的多少来排序
    global Num_Of_Satellite;
    Sequence = [];
    Sensor_Info = State{1,4};
    [a,Num] = size(G_Temp);
    Sequence_ = zeros(2,Num);
    for k = 1:Num
        if ~ismember(k,Who_Can)
            Sequence_(2,k) = -1;
        end
        Sequence_(1,k) = k;
    end
    for k = 1:Num
        if ismember(k,Who_Can)
            for j = 1:a
                if (~Is_Not_Own_Sensor(j,k,Sensor_Info)) && (G_Temp(j,k) == 2)
                    [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
                        = Extract_Corresponding_Sensor_Info(j,k,Sensor_Info);
                    if (Sender_Carrier == i)||(Object == i)
                        if If_Relative
                            Sequence_(2,k) = Sequence_(2,k) + Dimension;
                        else
                            Sequence_(2,k) = Sequence_(2,k) + Num_Of_Satellite;
                        end
                    end
                end
            end
        end
    end
    Sequence_ = Sequence_'; % 转置数组
    Sequence_ = sortrows(Sequence_, 2, 'descend'); % 按照第二列降序排序
    Sequence_ = Sequence_'; % 再次转置回原来的形状
    for k = 1:Num
        if Sequence_(2,k) ~= -1
            Sequence = [Sequence,Sequence_(1,k)];
        end
    end
end