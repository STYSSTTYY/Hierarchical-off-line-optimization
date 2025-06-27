function Score2 = Find_The_Number_Of_Corresponding_Message_new(Est,FC_Now,A_Temp,Sensor_Info,Num_Of_Satellite,Flag_OK)
% 找出动作中有多少条指定有关载体Est中的信息
    Score2 = 0;
    if Flag_OK == 0
        for i = 1:length(Est)
            Score2_ = Find_The_Number_Of_Corresponding_Message_(Est(i),FC_Now,A_Temp,Sensor_Info,Num_Of_Satellite);
            Score2 = Score2 + Score2_;
        end
    elseif Flag_OK == 1
        for i = 1:length(Est)
            Score2_ = Find_The_Number_Of_Corresponding_Message_R(Est(i),FC_Now,A_Temp,Sensor_Info,Num_Of_Satellite);
            Score2 = Score2 + Score2_;
        end
    end
end