function [G,X,Flag2,Relation_Map_,Observation_Map_,Select_Carrier_,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy_1(Temp,Estimations_Positions,A_Array,State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier,If_Random)
% 还没写，性能一个都不达标时，生成一个G，X
% Flag是一个标志，Flag=0代表无可用动作且动作输出为NAN，Flag=1代表正常动作，Flag=2代表最后一个动作NaN
% Temp储存了总的来看是哪些状态估计的精度没有达到要求。Temp上面是一个数组，代表这些不符合要求，不达标的是1，达标的是0
    E = Generate_Carrier_Need_Calculating(G,X);
    js = 0;
    Flag_Central = 0;
    Flag_Partial_Concentration = 0;
    RC_All = [];
    while all(E==0)&&(Flag_Central==0)
        if ((isempty(A_Array)) && (js==0))
            [G,X,Relation_Map,Observation_Map,Select_Carrier,Flag2] = Try_Self(State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier);  % 尝试用自己的信息解算
            E = Generate_Carrier_Need_Calculating(G,X);
            js = js+1;
        else 
            [G,X,Relation_Map,Observation_Map,Select_Carrier,Flag2,Flag_Central,Flag_Partial_Concentration,RC_All] = Try_Self_more(Temp,Estimations_Positions,A_Array,State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier,If_Random,js);  % 尝试用自己的信息解算后尝试进一步融合
            E = Generate_Carrier_Need_Calculating(G,X);
            js = js+1;
            if js>=3
                Flag2 = 0;
                G = NaN;
                X = NaN;
                break;
            end
        end
        if Flag_Central==1  % 如果必须采用完全集中式
        end
    end
    Relation_Map_ = Relation_Map;
    Observation_Map_ = Observation_Map;
    Select_Carrier_ = Select_Carrier;
end