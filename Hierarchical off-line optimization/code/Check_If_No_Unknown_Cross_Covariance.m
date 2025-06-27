function flag = Check_If_No_Unknown_Cross_Covariance(A_New,A_Array,S)
% 检查有无互协方差未知问题 无1有0
    flag = 1;
    Sensor_Info = S{1,4};
    G_New = A_New{1,1};
    X_New = A_New{1,2};
    E_New = A_New{1,3};
    Num = length(E_New);
    [m,~] = size(G_New);
    Observation_Trans_Graph = Build_Observation_Trans_Graph(G_New,X_New,A_Array,Sensor_Info);  % 根据相对观测和绝对观测信息各个时序上的传输结合最新的动作，建立一张最新的观测传输矩阵。
    Estimation_Trans_Graph = Build_Estimation_Trans_Graph(A_New,A_Array,S);  % 改！ 根据状态估计各个时序上的传输结合最新的动作，建立一张最新的状态估计传输矩阵。
    R1 = Check_If_Have_Multipath__(Observation_Trans_Graph,Num,m);
    R2 = Check_If_Have_Multipath_(Estimation_Trans_Graph,Num);
    if (R1) || (R2)  % 检查有向图是否存在多径，是1否0
        flag = 0;
    else
        flag = 1;
    end
end