function Flag = Is_Not_Own_Estimations(j,i,Sensor_Info)
% 判断传输到载体i的状态估计是不是自己储存的（自己储存的状态估计不需要占用传输资源）1不是自己的0是自己的
    Num = length(Sensor_Info);
    a = i*Num + 1 - Num;
    b = i*Num;
    if (j>=a) && (j<=b)
        Flag = 0;
    else 
        Flag = 1;
    end 
end