function [X_,Z_Dimension,X_Dimension,Which_Has_Four_Dimension] = Carriers_Will_Be_Estimated_i_(Carrier_i,A,X_Carrier_Number,Sensor_Info,Num_Of_Satellite)
% 输入即将采取的动作，载体自己储存有的状态估计的编号，输出这个载体理论上需要解算的状态估计的编号
% X_:[Carrier1,Carrier2,...],将要估计的载体的编号,Z_Dimension,载体i上将要解算的观测Z的总维度,X_Dimension,状态估计X的总维度,Which_Has_Four_Dimension,记录那些有四维的状态估计
    Num = length(Sensor_Info);
    A_Sensor_Trans = A{1,1};
    A_Estimation_Trans = A{1,2};
    [m,~] = size(A_Sensor_Trans);
    X_ = [];
    x_ = [];  % 用来记录哪些状态估计是四维的。
    temp1 = [];
    Z_Dimension = 0;
    X_Dimension = 0;
    for j = 1:m
        if A_Sensor_Trans(j,Carrier_i)==1
            [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
            = Extract_Corresponding_Sensor_Info(j,Carrier_i,Sensor_Info);  % 由于不考虑转发，所以发送相对观测的那个载体必然也是这个相对观测的一端
            if If_Relative
                X_ = [X_;Sender_Carrier;Object];
                x_ = [x_;0;0];
                Z_Dimension = Z_Dimension + Dimension;
            else
                X_ = [X_;Sender_Carrier];
                x_ = [x_;1];   % 那些是四维[x,y,z,t]的状态估计都记录下来。 
                Z_Dimension = Z_Dimension + Num_Of_Satellite;
            end
        end
    end
    [m,~] = size(A_Estimation_Trans);
    for j = 1:m
        if A_Estimation_Trans(j,Carrier_i)==1
            [~,~,Object] = Extract_Corresponding_Carrier(j,Carrier_i,Num);
            X_ = [X_;Object];
            x_ = [x_;0];
            Z_Dimension = Z_Dimension + 3;  % 一个发送的状态估计有[x,y,z]三个维度
        end
    end
    for i = 1:length(x_)
        if x_(i,1)==1
            temp1 = [temp1;X_(i,1)];
        end
    end
    Which_Has_Four_Dimension = (unique(temp1))';
    X_Dimension = length(unique(temp1)) + X_Dimension;
    X_Carrier_Number = X_Carrier_Number';
    X_ = X_';
    X_ = [X_,X_Carrier_Number];
    X_ = unique(X_);
    X_Dimension = X_Dimension + 3*length(X_);
end