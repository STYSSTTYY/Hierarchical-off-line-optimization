function G_ = Gather_All_Available_Observations_(i,G,X,A_Array,S,Num_Of_Satellite)
% 根据载体状态和历史动作，将剩下的观测信息中能用的都汇聚到某个载体i上来

    [m,~] = size(G);
    G___ = G;
    parfor j = 1:m
        G__ = G;
        G__(j,i) = 1;
        A_New = cell(1,3);
        A_New{1,1} = G__;  
        A_New{1,2} = X;  % 组合成一个新的A
        A_New{1,3} = Generate_Carrier_Need_Calculating(G__,X); 
        if Check_If_No_Unknown_Cross_Covariance_last(A_New,A_Array,S,Num_Of_Satellite)
            G___(j,i) = 1;
        end
    end
    G_ = G___;
end