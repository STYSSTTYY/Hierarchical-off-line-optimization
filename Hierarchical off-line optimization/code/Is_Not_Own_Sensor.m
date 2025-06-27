function Flag = Is_Not_Own_Sensor(j_,i,Sensor_Info)
% 判断传输到载体i的传感器是不是自己的传感器（自己的传感器不需要占用传输资源）1不是自己的0是自己的
    add = 0;
    for j = 1:i
        [b,~] = size(Sensor_Info{j,1}{1,2});
        add = add + b;
    end
    add2 = add - b + 1;
    if (j_>=add2) && (j_<=add)
        Flag = 0;
    else 
        Flag = 1;
    end
end