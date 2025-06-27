function [A,S,Relation_Map_,Observation_Map_,Select_Carrier_,Flag3,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy_Step(G,X,E,State,A_Array,S_Final,Relation_Map,Observation_Map,Select_Carrier,If_Random)
% 策略选动作
% Flag是一个标志，Flag=0代表无可用动作且动作输出为NAN，Flag=1代表正常动作，Flag=2代表最后一个动作NaN
% Relation_Map Num*Num矩阵，只记录不同载体需要哪些程度的融合信息，不记录具体在哪里融合
% Observation_Map Num*Num矩阵，只记录不同载体之间有哪些观测（绝对、相对）
% Select_Carrier 1*Num矩阵，记录载体的结果需要在哪里解算
    Flag_Central = 0;
    Flag_Partial_Concentration = 0;
    RC_All = [];
    Case_ = 0;
    A = cell(1,3);
    A{1,1} = G;
    A{1,2} = X;
    A{1,3} = E;
    [m1,n1] = size(G);
    [m2,n2] = size(X);
    P_All = Extract_Performance_Of_State(State{1,1});  % 从当前状态中提取出所有载体上的互协方差矩阵
    P = Sort_Out_Best_from_all_P_Trace(P_All);  % 从所有载体上当前存在的互协方差矩阵中整合出一个最好的代表上限，暂时只整理状态估计的方差,互协方差先不管
    if If_Satisfy_All_Requirements(State,S_Final,P_All)  % 如果已经满足了全部的要求，已经满足了1否0
        A{1,1} = NaN;
        A{1,2} = NaN;
        A{1,3} = NaN;  % 如果是的的话，输出一个空的动作
        l = length(State{1,5});
        State{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
        S = State;
        Flag3 = 2;
        Relation_Map_ = Relation_Map;
        Observation_Map_ = Observation_Map;
        Select_Carrier_ = Select_Carrier;
        return;
    elseif If_Satisfy_Performance_And_Costs(State,S_Final,P_All)  % 如果已经满足了性能要求和代价要求，已经满足了1否0
        A{1,1} = G;
        [Flag,X_,E_] = Build_X_Final(State,S_Final,P_All,X,E);  % 建立一个最后的，仅仅用于传输结果到正确位置的矩阵，Flag返回是否存在这样的符合代价要求的矩阵，存在1，不存在0
        if Flag
            A{1,2} = X_;
            A{1,3} = E_;
            % 如果这个动作可以采用
            l = length(State{1,5});
            State{1,5}{l+1,1} = A;  % 将已经判断可以采用的动作也压入已经采取过的动作里面以免下次又被采用
            Cal = State{1,3}{1,1};
            % Com = Com_Cost(A,State); % 计算该动作的通信代价
            Com = Com_Cost_(A,State);  % 计算该步传输的通讯代价
            State{1,3}{1,1} = Cal;
            State{1,3}{1,2} = Com;
            %A{1,3} = E;
            S = State;
            Flag3 = 2;
            Relation_Map_ = Relation_Map;
            Observation_Map_ = Observation_Map;
            Select_Carrier_ = Select_Carrier;
            return;
        else
            A{1,1} = NaN;
            A{1,2} = NaN;
            A{1,3} = NaN;
            l = length(State{1,5});
            State{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
            S = State;
            Flag3 = 0;
            Relation_Map_ = Relation_Map;
            Observation_Map_ = Observation_Map;
            Select_Carrier_ = Select_Carrier;
            return;
        end
    elseif If_Some_Satisfy_Performance_And_Costs(State,S_Final,P_All,P)  % 如果部分载体已经满足了性能要求和代价要求，已经满足了1否0
        [~,Temp,Estimations_Positions] = If_Some_Satisfy_Performance_And_Costs(State,S_Final,P_All,P);
        [G,X,Flag2,Relation_Map,Observation_Map,Select_Carrier,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy_1(Temp,Estimations_Positions,A_Array,State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier,If_Random);  % 有若干个性能达标时，生成一个G，X
        Case_ = 1;
        Flag3 = Flag2;
        if Flag3 == 0
            A{1,1} = NaN;
            A{1,2} = NaN;
            A{1,3} = NaN;
            l = length(State{1,5});
            State{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
            S = State;
            Flag3 = 0;
            Relation_Map_ = Relation_Map;
            Observation_Map_ = Observation_Map;
            Select_Carrier_ = Select_Carrier;
            return;
        end
    elseif If_Cost_Meets_(State,S_Final)  % 其它，底线是必须满足Cost要求
        [Temp,Estimations_Positions] = If_Some_Satisfy_Performance_And_Costs_(S_Final,P_All,P);
        [G,X,Flag2,Relation_Map,Observation_Map,Select_Carrier,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy_1(Temp,Estimations_Positions,A_Array,State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier,If_Random);  % 性能一个都不达标时，生成一个G，X
        Case_ = 2;
        Flag3 = Flag2;
        if Flag3 == 0
            A{1,1} = NaN;
            A{1,2} = NaN;
            A{1,3} = NaN;
            l = length(State{1,5});
            State{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
            S = State;
            Flag3 = 0;
            Relation_Map_ = Relation_Map;
            Observation_Map_ = Observation_Map;
            Select_Carrier_ = Select_Carrier;
            return;
        end
    else
        A{1,1} = NaN;
        A{1,2} = NaN;
        A{1,3} = NaN;
        l = length(State{1,5});
        State{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
        S = State;
        Flag3 = 0;
        Relation_Map_ = Relation_Map;
        Observation_Map_ = Observation_Map;
        Select_Carrier_ = Select_Carrier;
        return;
    end
    A{1,1} = G;
    A{1,2} = X;
    A{1,3} = Generate_Carrier_Need_Calculating(G,X);
    Relation_Map_ = Relation_Map;
    Observation_Map_ = Observation_Map;
    Select_Carrier_ = Select_Carrier;
    S = State;
end