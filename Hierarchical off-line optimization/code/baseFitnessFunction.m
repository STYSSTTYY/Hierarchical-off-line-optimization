function fitness = baseFitnessFunction(x,G,X,Est,Estimations,FC_Now,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base)
    warning off;
    Flag_OK = 0;
    [n_G,Num] = size(G);
    [n_X,~] = size(X);
    A_Temp = cell(1,3);
    A_Temp{1,1} = zeros(n_G,Num);
    A_Temp{1,1}(:,FC_Now) = x(1:n_G)';
    A_Temp{1,2} = zeros(n_X,Num);
    A_Temp{1,2}(:,FC_Now) = x(n_G+1:n_G+n_X)';
    A_Temp{1,3} = Generate_Carrier_Need_Calculating(A_Temp{1,1},A_Temp{1,2});
    [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S_(FC_Now,A_Temp,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);  % 改！
    if Flag2
        [A_Temp,~,~]= Eliminate_Carrier_Cant_Solved_(Carriers_Number,X_Carrier_Number_All,FC_Now,A_Temp,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);
    end
    Cal = Cal_Cost__(A_Temp,State,Num_Of_Satellite);
    Com = Com_Cost__(A_Temp,State,Num_Of_Satellite,Base);
    if ~If_Cost_Meets(Cal,Com,S_Final)
        Score_ = -inf;
        fitness = -Score_;
        return;
    end
    if ~Check_If_No_Unknown_Cross_Covariance_last(A_Temp,A_Array,State,Num_Of_Satellite) % 改！
        Score_ = -inf;
        fitness = -Score_;
        return;
    end

    % 按有效信息条数算得分
    Score_Temp = 0;
    Score1 = 1;  % 有效信息1分1条
    Score2 = Find_The_Number_Of_Corresponding_Message_new(Est,FC_Now,A_Temp,State{1,4},Num_Of_Satellite,Flag_OK);  % 找出动作中载体Selected_Carrier上有多少条指定有关载体i的信息

    % 如果解算能达到标准就是大大的加分
    Flag_Progress = 1;
    [flag_cal,~,P_All] = Calculating_X_And_P_(A_Temp,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);
    for i = 1:length(Estimations)
        if ~flag_cal
            fitness = -Score_Temp;
            break;
        end
        P_Temp = P_All{1,FC_Now}((Estimations(i)-1)*3+1:Estimations(i)*3,(Estimations(i)-1)*3+1:Estimations(i)*3);
        P_Tar = S_Final{1,1}((Estimations(i)-1)*3+1:Estimations(i)*3,(Estimations(i)-1)*3+1:Estimations(i)*3);
        P_Now = State{1,1}{1,FC_Now}((Estimations(i)-1)*3+1:Estimations(i)*3,(Estimations(i)-1)*3+1:Estimations(i)*3);
        if ~isnan(trace(P_Tar))
            if ~isnan(trace(P_Temp))
                if trace(P_Temp)<=trace(P_Tar)
                     Score_Temp =  Score_Temp + 500;  % 对于某状态估计实现精度了
                     Flag_OK = 1;
                end
            end
            if ~isnan(trace(P_Now))
                if (trace(P_Now)==trace(P_Temp))&&(trace(P_Temp)>trace(P_Tar))  %  有进步才能有分数
                    Flag_Progress = 0;
                end
            end
        end
    end

    if ~Flag_Progress
        Score2 = 0;
    end

    if Flag_OK == 0
        Score_Temp = Score_Temp + Score2*Score1;
    elseif Flag_OK == 1
        T = Find_The_Number_Of_Corresponding_Message_new(Est,FC_Now,A_Temp,State{1,4},Num_Of_Satellite,Flag_OK);
        Score_Temp = 500 - T + Score2*Score1;
    end
    fitness = -Score_Temp;

end