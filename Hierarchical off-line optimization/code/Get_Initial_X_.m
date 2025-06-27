function Initial_X = Get_Initial_X_(X_Carrier_Number_All,Which_Has_Four_Dimension,Carriers_Position)
% 为了减少收敛所需次数，将真实值取做初值
    X_ = [];
    X = [];
    if isempty(X_Carrier_Number_All)
        Initial_X = [];
        return;
    end
    for i = 1:length(X_Carrier_Number_All)
        temp = 0;
        for j = 1:length(Which_Has_Four_Dimension)
            if X_Carrier_Number_All(1,i) == Which_Has_Four_Dimension(1,j)
                temp = 1;
            end
        end
        if temp==1
            X_ = Get_Posistion_i_A(X_Carrier_Number_All(1,i),Carriers_Position);
        else
            X_ = Get_Posistion_i_R(X_Carrier_Number_All(1,i),Carriers_Position);
        end
        X = [X;X_];
    end
    Initial_X = X;
end