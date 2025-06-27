function Com = Com_Cost__(A,S,Num_Of_Satellite,Base)
% 根据动作计算每一步的通讯代价 将收到的和发送的数据量分开计算。 
    [a,aa] = size(A{1,1});
    [b,bb] = size(A{1,2});
    if ((a==1)&&(aa==1))&&((b==1)&&(bb==1))
        if (isnan(A{1,1})) && (isnan(A{1,2}))
            Com = Cost_Before;
            return;
        end
    end
    Sensor_Info = S{1,4};
    Cost_Before = S{1,3}{1,2};
    Num = length(Sensor_Info);
    Cost = zeros(1,Num);
    A_Sensor_Trans = A{1,1};
    if isnan(A_Sensor_Trans)
        Com = Cost_Before;
        return;
    end
    [m_s,~] = size(A_Sensor_Trans);
    A_Estimation_Trans = A{1,2};
    [m_e,~] = size(A_Estimation_Trans);
    If_Sensor_Trans = 1;
    for i = 1:Num
        for j = 1:m_s
            if (A_Sensor_Trans(j,i)==1) && (Is_Not_Own_Sensor(j,i,Sensor_Info))  % 自己的传感器不需要占用传输资源
               [Sender_Carrier,Receivor_Carrier,~,If_Relative,Dimension,~,~] =...
                   Extract_Corresponding_Sensor_Info(j,i,Sensor_Info);
               Cost(1,Sender_Carrier) = Cost(1,Sender_Carrier) + Data_Size_(If_Relative,Dimension,Num_Of_Satellite,If_Sensor_Trans,Base);  % 改！
               Cost(1,Receivor_Carrier) = Cost(1,Receivor_Carrier) + Data_Size_(If_Relative,Dimension,Num_Of_Satellite,If_Sensor_Trans,Base);   % 改！
            end
        end
    end
    If_Sensor_Trans = 0;
    for i = 1:Num
        for j = 1:m_e
            if (A_Estimation_Trans(j,i)==1) && (Is_Not_Own_Estimations(j,i,Sensor_Info))  % 自己储存的状态估计不需要占用传输资源
               [Sender_Carrier,Receivor_Carrier,~] = Extract_Corresponding_Carrier(j,i,Num);
               Cost(1,Sender_Carrier) = Cost(1,Sender_Carrier) + Data_Size_(0,0,Num_Of_Satellite,If_Sensor_Trans,Base);   % 改！ 
               Cost(1,Receivor_Carrier) = Cost(1,Receivor_Carrier) + Data_Size_(0,0,Num_Of_Satellite,If_Sensor_Trans,Base);    % 改！
            end
        end
        for k = 1:Num  % 这边考虑协方差的传输
            temp1 = [];
            for j = 1:m_e
                if ((~Is_Not_Own_Estimations(j,k,Sensor_Info)) + (Is_Not_Own_Estimations(j,i,Sensor_Info))...
                        + (A_Estimation_Trans(j,i)==1) == 3) % 状态估计是储存在载体k上的而不是储存在自己载体上的，且状态估计传输矩阵上确实要被表示为传输
                    [~,~,Object] = Extract_Corresponding_Carrier(j,i,Num);
                    temp1 = [temp1,Object];  % 这样可以找到全部载体K要向载体i传输的状态估计的载体的编号
                end
            end
            Sender_Carrier = k; Receivor_Carrier = i;
            Cross_Covariance_Matrix_i = Get_Corresponding_Cross_Covariance_Matrix_i(Sender_Carrier,temp1,S);  % 找出载体k要向载体i传输怎样的互协方差矩阵
            Cost(1,Sender_Carrier) = Cost(1,Sender_Carrier) + Data_Size_Cross_Covariance_Matrix__(Cross_Covariance_Matrix_i,Base);   % 改！% 计算要传输的互协方差矩阵的通信代价
            Cost(1,Receivor_Carrier) = Cost(1,Receivor_Carrier) + Data_Size_Cross_Covariance_Matrix__(Cross_Covariance_Matrix_i,Base);   % 改！
        end
    end
    Com = Cost_Before + Cost;
end