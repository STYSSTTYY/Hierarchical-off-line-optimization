function Score2 = Find_The_Number_Of_Corresponding_Message_(i,Selected_Carrier,A_Temp,Sensor_Info,Num_Of_Satellite)
% 找出动作中有多少条指定有关载体i的信息
    Score2 = 0;
    G = A_Temp{1,1};
    X = A_Temp{1,2};
    E = A_Temp{1,3};
    [m,Num] = size(G);
    [n,~] = size(X);
    for j = 1:m
        if G(j,Selected_Carrier) == 1
            [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
                = Extract_Corresponding_Sensor_Info(j,Selected_Carrier,Sensor_Info);
            if (If_Relative) && ((Sender_Carrier == i) || (Object == i))
                %Score2 = Score2 + Dimension;
                Score2 = Score2 + 1;
            elseif (~If_Relative) && (Sender_Carrier == i)
                %Score2 = Score2 + Num_Of_Satellite;
                Score2 = Score2 + 1;
            end
        end
    end
    for j = 1:n
        if X(j,Selected_Carrier) == 1
            [~,~,Object] = Extract_Corresponding_Carrier(j,Selected_Carrier,Num);
            if Object == i
                Score2 = Score2 + 3;
            end
        end
    end
end