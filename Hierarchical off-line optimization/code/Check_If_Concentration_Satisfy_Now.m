function Flag_All_ = Check_If_Concentration_Satisfy_Now(EST,FC_Now,Estimation,P_Tar,G,X,State)
%如果理论上仍然不行的话，判断集中式是否满足，是Flag_All_为1，否为0
    S_Temp = State;
    [a,b] = size(State{1,1}{1,1});
    [c,d] = size(State{1,2}{1,1});
    [n_G,Num] = size(G);
    [n_X,~] = size(X);
    for i = 1:Num
        S_Temp{1,1}{1,i} = NaN*ones(a,b);
        S_Temp{1,2}{1,i} = NaN*ones(c,d);
    end
    G_ = zeros(n_G,Num);
    X_ = zeros(n_X,Num);
    Sensor_Info = State{1,4};
    for Row = 1:n_G
        [Sender_Carrier,~,~,~,~,~,~] ...
            = Extract_Corresponding_Sensor_Info(Row,1,Sensor_Info);
        if ismember(Sender_Carrier,EST)
            G_(Row,FC_Now) = 1;
        end
    end
    A = cell(1,3);
    A{1,1} = G_;  
    A{1,2} = X_;  % 第一步时根本就没有可以传输的状态估计。
    E = Generate_Carrier_Need_Calculating(G_,X_); 
    A{1,3} = E;
    for i = 1:Num
        if E(i)==1
            [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S(i,A,S_Temp);
            if (E(i)==1) && (Flag2==1)
                [A,~,~]= Eliminate_Carrier_Cant_Solved(Carriers_Number,X_Carrier_Number_All,i,A,S_Temp);
            end
        end
    end
    [~,~,P_All] = Calculating_X_And_P(A,S_Temp);
    P_Temp = P_All{1,FC_Now}((Estimation-1)*3+1:Estimation*3,(Estimation-1)*3+1:Estimation*3);
    if ~isnan(trace(P_Tar))
        if ~isnan(trace(P_Temp))
            if trace(P_Temp)<=trace(P_Tar)
                Flag_All_ = 1;  % 这一轮理论上可以实现精度
            else
                Flag_All_ = 0;
            end
        else
            Flag_All_ = 0;
        end
    else
        Flag_All_ = 1;
    end
end