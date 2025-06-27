function Carriers_Number3 = Find_Which_Carrier_Failed3_Comcentration(Carrier_i,A,S)
% 还有一些剩下的情况，根据H_New来判断
    Estimations = S{1,2};
    Sensor_Info = S{1,4};
    Num = length(S{1,4});
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    X = [];
    if ~isempty(X)
        X_Carrier_Number = X(:,1);
    else
        X_Carrier_Number = [];
    end
    [X_Carrier_Number_All,Z_Dimension,X_Dimension,Which_Has_Four_Dimension] = ...
        Carriers_Will_Be_Estimated_i(Carrier_i,A,X_Carrier_Number,Sensor_Info);  % 改！根据动作得出载体i上将要解算的观测Z的总维度，状态估计X的总维度
    Delta_X = zeros(X_Dimension,1);
    H_ = zeros(Z_Dimension,X_Dimension);
    C_ = zeros(Z_Dimension,Z_Dimension);
    [C,Z] = Get_C_Z_i(Carrier_i,A,S);  %  改！根据动作和状态给出加权最小二乘估计的C，Z
    Initial_X = Get_Initial_X(X_Carrier_Number_All,Which_Has_Four_Dimension);  %  改！为了减少收敛所需次数，将真实值取做初值
    X_New = Initial_X;
    Delta_Z = Z - Z_Iteration(Carrier_i,A,S,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 改！获取每一次迭代时的Delta_Z
    H_New = Get_H_New(Carrier_i,A,S,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,H_);  % 改！获取每一次迭代时最新的H
    R = rref(H_New);
    if X_Dimension > Z_Dimension
        Carriers_Number3 = [];
        return;
    end
    Temp = zeros(1,X_Dimension);
    temp1 = 1;
    j = 1;
    while 1
        while R(j,temp1) ~= 1
            Temp(1,temp1) = 1;
            if temp1 >= X_Dimension
                break;
            else
                temp1 = temp1 + 1;
            end
        end
        if temp1 >= X_Dimension
            break;
        else
            temp1 = temp1 + 1;
            j = j + 1;
        end
    end
    Unknown_X = X_Unknown(Temp,X_Carrier_Number_All,Which_Has_Four_Dimension);
    Carriers_Number3 = Unknown_X;
end