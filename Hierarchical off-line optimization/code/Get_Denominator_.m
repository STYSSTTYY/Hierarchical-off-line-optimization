function D = Get_Denominator_(Sender_Carrier,If_Relative,Dimension,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,Num_Of_Satellite,Satellite_Position)
% 获取每一轮迭代时对应项的分母
    if If_Relative
        D = zeros(Dimension,1);
        [X_Of_Sender_Carrier,X_Of_Object] = ...
            Extract_X_From_X_New(Sender_Carrier,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 从X_New中提取对应的X(3D)
        if Dimension==1
            D = norm(X_Of_Object - X_Of_Sender_Carrier);
        elseif Dimension==3
            D = X_Of_Object - X_Of_Sender_Carrier;
        end
    else
        D = zeros(Num_Of_Satellite,1);
        X_Of_Sender_Carrier = ...
            Extract_X4_From_X_New(Sender_Carrier,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 从X_New中提取对应的X(4D)
        for i = 1:Num_Of_Satellite
            Satellite = Satellite_Position(1:3,i);
            D(i,1) = norm(Satellite - X_Of_Sender_Carrier(1:3,1));
        end
    end
end