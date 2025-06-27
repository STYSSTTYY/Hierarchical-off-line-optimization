function [Carriers_Had_Used,Relation_Map_] = Which_Carrier_Had_Used(Num,Carrier,Relation_Map,G,X,A_Array,S,S_Final)
% 找出那些载体的信息已经被全部使用了
% Estimations_Positions是一个元胞，它一共有Num行，代表每一个载体的状态估计，元胞内存有一数组，代表这状态估计存在于哪些载体上
    Carriers_Had_Used = [];
    for i = 1:Num
        if i~=Carrier
            if (Relation_Map(i,Carrier) == 2)
                X_i = Gather_All_Available_Estimations_i(i,Carrier,G,X,A_Array,S,S_Final);  % 在X_i中记录所有载体i的可以放到载体Carrier来的状态估计
                G_i = Gather_All_Available_Observations_i(i,Carrier,G,X,A_Array,S,S_Final);  % 在G_i中记录所有载体i的可以放到载体Carrier来的观测
                if (all(X_i==0)) && (all(G_i==0))
                    Relation_Map(i,Carrier) = 3;
                    Carriers_Had_Used = [Carriers_Had_Used,i];
                    continue;
                end
            elseif (Relation_Map(i,Carrier) == 3) || (Relation_Map(i,Carrier) == 4)  % 4代表载体上存在一些解算不了的观测留到后续
                Carriers_Had_Used = [Carriers_Had_Used,i];
            end
        elseif i==Carrier
            G_i = Gather_All_Available_Observations_i(i,Carrier,G,X,A_Array,S,S_Final);  % 在G_i中记录所有载体i的可以放到载体Carrier来的观测
            if (all(G_i==0))
                Carriers_Had_Used = [Carriers_Had_Used,i];
                continue;
            end
        end
    end
    Relation_Map_ = Relation_Map;
end