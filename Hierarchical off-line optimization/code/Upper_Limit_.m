function P_Upper_Limit = Upper_Limit_(State)
% 检查当前状态下性能能够达到的上限(不考虑代价的情况下)
    Sensor_Info = State{1,4};
    G = Build_Observation_Trans_Matrix(Sensor_Info);
    X = Build_Estimation_Trans_Matrix(Sensor_Info);
    E = Build_Estimation_Matrix(Sensor_Info);
    E(1,1) = 1;  % 假设将所有的信息都集中到第一个载体上来，所以仅第一个载体需要解算
    A = cell(1,3);
    [m,n] = size(G);
    for i = 1:m
        G(i,1) = 1;  % 假设将所有的信息都集中到第一个载体上来，所以第一列的传感器传输都是1
    end
    A{1,1} = G;  
    A{1,2} = X;  % 第一步时根本就没有可以传输的状态估计。
    A{1,3} = E;  
    for i = 1:n
        [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S(i,A,State);
        if Flag2
            [A,~,~]= Eliminate_Carrier_Cant_Solved(Carriers_Number,X_Carrier_Number_All,i,A,State);
        end
    end
    [flag,~,P] = Calculating_X_And_P(A,State);  % 根据采取的动作和当前的状态进行解算
    if ~flag
        P_Upper_Limit = {[]};
        return;
    end
    P_Upper_Limit= P;
end