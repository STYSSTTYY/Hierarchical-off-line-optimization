function [G_,X_,Relation_Map_,Observation_Map_,Select_Carrier_Temp_,RC,Flag_Partial_Concentration] = Decide_G_X(FC_Now,Estimations,Estimation_Around_Saper,Relation4,Flag_EA,Relation_Map,Observation_Map,Select_Carrier_Temp,G,X,A_Array,State,S_Final,Carriers_Had_Used)
% 定下来需要传输的信息并修改相应的矩阵
    Flag_Partial_Concentration = 0;
    RC = [];
    G_ = G;
    X_ = X;
    [n_G,Num] = size(G);
    [n_X,~] = size(X);
    global Num_Of_Satellite;
    global Carriers_Position;
    global Satellite_Position;
    global Base;

    if ~Flag_EA  % 如果再没有多余的信息可以使用，则返回考虑集中式
        Relation_Map_ = Relation_Map;
        Observation_Map_ = Observation_Map;
        Select_Carrier_Temp_ = Select_Carrier_Temp;
        return;
    end

    % 先判断如果将所有这些信息全部用上可不可以实现精度要求
    Relation4_New = [];
    for i = 1:length(Estimations)
        Est = sort(unique([Estimations(i),Estimation_Around_Saper{i,1},Relation4{i,1}]));
        EST = sort(unique([Estimations(i),Estimation_Around_Saper{i,1},Relation4{i,1},Carriers_Had_Used]));
        G_i = Gather_All_Available_Observations_i_m(Est,FC_Now,G,X,A_Array,State,S_Final,Relation_Map);
        X_i = Gather_All_Available_Estimations_i_m(Est,FC_Now,G,X,A_Array,State,S_Final,Relation_Map);
        A_New_ = cell(1,3);
        A_New_{1,1} = G;
        A_New_{1,2} = X;
        A_New_{1,1}(:,FC_Now) = G_i;
        A_New_{1,2}(X_i==2,FC_Now) = 1;
        A_New_{1,3} = Generate_Carrier_Need_Calculating(A_New_{1,1},A_New_{1,2});
        [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S(FC_Now,A_New_,State);
        A_New = A_New_;
        if Flag2==1
            [A_New,~,~]= Eliminate_Carrier_Cant_Solved(Carriers_Number,X_Carrier_Number_All,FC_Now,A_New_,State);
        end
        [~,~,P_All] = Calculating_X_And_P(A_New,State);
        P_Temp = P_All{1,FC_Now}((Estimations(i)-1)*3+1:Estimations(i)*3,(Estimations(i)-1)*3+1:Estimations(i)*3);
        P_Tar = S_Final{1,1}((Estimations(i)-1)*3+1:Estimations(i)*3,(Estimations(i)-1)*3+1:Estimations(i)*3);
        if ~isnan(trace(P_Tar))
            if ~isnan(trace(P_Temp))
                if trace(P_Temp)<=trace(P_Tar)
                    Flag_All = 1;  % 这一轮理论上可以实现精度
                else
                    Flag_All = 0;
                end
            else
                Flag_All = 0;
            end
        else
            Flag_All = 1;
        end
        G_Unable = zeros(length(G_i),1);
        for j = 1:length(G_i)
            if (A_New{1,1}(i,FC_Now)==0)&&(G_i(i)==1)
                G_Unable(j)= 1;  % 把不能用的观测信息记住
            end
        end
        [Flag,Optional_Action] = GA_New(Flag_All,A_New{1,1}(:,FC_Now),G_Unable,X_i,Est,Estimations,FC_Now,G,X,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base);  % 用遗传算法实现每一步的选取
        js = 0;
        while (Flag<1) && (js<2)
            [Flag,Optional_Action] = GA_New(Flag_All,A_New{1,1}(:,FC_Now),G_Unable,X_i,Est,Estimations,FC_Now,G,X,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base);  % 用遗传算法实现每一步的选取
            js = js+1;
        end

        % 这边是用来生成局部集中式的模块的
        if Flag_All==0
            Flag_All_ = Check_If_Concentration_Satisfy_Now(EST,FC_Now,Estimations(i),P_Tar,G,X,State);  % 如果理论上仍然不行的话，判断集中式是否满足，是Flag_All_为1，否为0
        else
            Flag_All_ = 1;
        end
        if (Flag==1)&&(Flag_All_==1)&&(Flag_All==0)
            if Flag_All_ == 1 
                A_Array_Temp = A_Array;
                A_Array_Temp(end+1,1) = {Optional_Action};
                Flag_If_Satisfy_Now = Check_If_Satisfy_Now(A_Array,X,State,FC_Now,Estimations(i),S_Final);  % 判断现在是否满足要求，满足要求Flag_If_Satisfy_Now=1，不满足要求Flag_If_Satisfy_Now=0
            end
            if ~Flag_If_Satisfy_Now  % 如果理论上满足但是现实不满足的话，采用局部集中
                [Flag_Partial_Concentration, RC_] = Take_Partial_Concentration_Action(EST);  % 生成一个局部集中式的动作
                RC = [RC,RC_];
                if ~isempty(RC)
                    RC = sort(unique(RC));
                end
            end
        end

        if Flag == 0  % 若没有可用信息
            G_ = Optional_Action{1,1};
            X_ = Optional_Action{1,2};
            [~,Relation_Map_] = Find_Relation4(Est,FC_Now,Relation_Map,G_,A_New{1,1}(:,FC_Now),X_,A_Array,State,S_Final);  % 判断信息是否属于4类
            G_ = zeros(n_G,Num);
            X_ = zeros(n_X,Num);
            Observation_Map_ = Observation_Map;
            Select_Carrier_Temp_ = Select_Carrier_Temp;
        elseif Flag==-1  % 若算力不足
            G_ = zeros(n_G,Num);
            X_ = zeros(n_X,Num);
            Relation_Map(FC_Now,FC_Now) = -1;
            Relation_Map_ = Relation_Map;
            Observation_Map_ = Observation_Map;
            Select_Carrier_Temp_ = Select_Carrier_Temp;
        elseif Flag==-2  % 若通讯不足
            G_ = zeros(n_G,Num);
            X_ = zeros(n_X,Num);
            Relation_Map(FC_Now,FC_Now) = -2;
            Relation_Map_ = Relation_Map;
            Observation_Map_ = Observation_Map;
            Select_Carrier_Temp_ = Select_Carrier_Temp;
        elseif Flag == 1
            [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S_(FC_Now,Optional_Action,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);  % 改！
            if Flag2
                [Optional_Action,~,~]= Eliminate_Carrier_Cant_Solved_(Carriers_Number,X_Carrier_Number_All,FC_Now,Optional_Action,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);
            end
            G_ = Optional_Action{1,1};
            X_ = Optional_Action{1,2};
            [~,Relation_Map_] = Find_Relation4(Est,FC_Now,Relation_Map,G_,A_New{1,1}(:,FC_Now),X_,A_Array,State,S_Final);  % 判断信息是否属于4类
            Observation_Map_ = Observation_Map;
            Select_Carrier_Temp_ = Select_Carrier_Temp;
        end
    end
end