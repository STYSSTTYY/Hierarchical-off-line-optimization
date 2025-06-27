function [State_,A_,Flag,Relation_Map_,Observation_Map_,Select_Carrier_,Flag_Central,Flag_Partial_Concentration,RC_All] = Partial_Concentration_(G,X,E,State,A_Array,S_Final,If_Random,RC_All_)
% 选取一个可行的局部集中的动作
    [Relation_Map,Observation_Map,Select_Carrier] = Build_Maps(G,X,E,State); % 建立三种矩阵
    [A_temp,State_temp,Relation_Map,Observation_Map,Select_Carrier,Flag2,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy_Step_Partial_Concentration(G,X,E,State,A_Array,S_Final,Relation_Map,Observation_Map,Select_Carrier,If_Random,RC_All_); % 策略选动作
    if Flag2==1
        A_ = A_temp;
        Cal = Cal_Cost(A_,State_temp); % 计算该动作的运算代价
        Com = Com_Cost(A_,State_temp); % 计算该动作的通信代价
        % 如果这个动作可以采用
        l = length(State_temp{1,5});
        State_temp{1,5}{l+1,1} = A_;  % 将已经判断可以采用的动作也压入已经采取过的动作里面以免下次又被采用
        State_temp{1,3}{1,1} = Cal;
        State_temp{1,3}{1,2} = Com;
        State_ = State_temp;
        Flag = 1;
        Relation_Map_ = Relation_Map;
        Observation_Map_ = Observation_Map;
        Select_Carrier_ = Select_Carrier;
    else
        A_ = A_temp;
        State_ = State_temp;
        Relation_Map_ = Relation_Map;
        Observation_Map_ = Observation_Map;
        Select_Carrier_ = Select_Carrier;
        if Flag2==2
            Flag = 2;
        else
            Flag = 0;
        end
    end
end