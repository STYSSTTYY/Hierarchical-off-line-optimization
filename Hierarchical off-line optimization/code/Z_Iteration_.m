function Z = Z_Iteration_(Carrier_i,A,S,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,Num_Of_Satellite,Satellite_Position)
% 获取每一次迭代时的Delta_Z
    Sensor_Info = S{1,4};
    G = A{1,1};
    A_Estimation_Trans = A{1,2};
    [m,~] = size(G);
    [n,Num] = size(A_Estimation_Trans);
    temp2 = [];
    Z = [];
    if isempty(X_Carrier_Number_All)
        Z = [];
        return;
    end
    for j = 1:m
        if G(j,Carrier_i)==1
            [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
                 = Extract_Corresponding_Sensor_Info(j,Carrier_i,Sensor_Info);
            D = Get_Denominator_(Sender_Carrier,If_Relative,Dimension,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,Num_Of_Satellite,Satellite_Position);  % 改！获取每一轮迭代时对应项的分母
            if ~If_Relative
                D_ = Delta_t_Multi_C_(Sender_Carrier,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,Num_Of_Satellite,Satellite_Position);  % 改！伪距里面还要多减去一项dt*c
                D = D + D_;
            end
            Z = [Z;D];
            temp2 = [];
        end 
    end
    for j = 1:n
        if A_Estimation_Trans(j,Carrier_i)==1
            [Sender_Carrier,~,Object] = Extract_Corresponding_Carrier(j,Carrier_i,Num);
            [~,X_Of_Object] = Extract_X_From_X_New(Sender_Carrier,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);
            D = X_Of_Object;
            Z = [Z;D];
        end
    end
end