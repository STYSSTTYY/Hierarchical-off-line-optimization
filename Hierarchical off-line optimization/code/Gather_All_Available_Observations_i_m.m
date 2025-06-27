function G_i = Gather_All_Available_Observations_i_m(Est,Carrier,G,X,A_Array,S,S_Final,Relation_Map)
% 在G_i中记录所有载体i的可以放到载体Carrier来的观测
    global Base;
    global Num_Of_Satellite;
    Estimations_Required = S_Final{1,2};
    Estimations_Required(isnan(Estimations_Required)) = 0;
    Com_Require = (sum(Estimations_Required)+1)*Base*12;  % 一定要留足所有状态估计传进来的资源外加把自己传出去的资源
    [m,~] = size(G);
    G_i = zeros(m,1);
    Sensor_Info = S{1,4};
    for j = 1:m
        [Sender_Carrier,~,~,If_Relative,Dimension,~] ...
            = Extract_Corresponding_Sensor_Info(j,Carrier,Sensor_Info);
        if (ismember(Sender_Carrier,Est) && (Relation_Map(Sender_Carrier,Carrier)<3)&&(G(j,Carrier) ~= 1))  % 如果是Est上的观测而且还没全部使用信息
            G(j,Carrier) = 1;
            A_New = cell(1,3);
            A_New{1,1} = G;  
            A_New{1,2} = X;  % 组合成一个新的A
            A_New{1,3} = Generate_Carrier_Need_Calculating(G,X); 
            if ~Check_If_No_Unknown_Cross_Covariance(A_New,A_Array,S)
                G_i(j) = 0;
                
            else
                Cost_Com_G = Data_Size_(If_Relative,Dimension,Num_Of_Satellite,1,Base) + Com_Require(Sender_Carrier);
                if ((Cost_Com_G + S{1,3}{1,2}(Sender_Carrier)) <= S_Final{1,3}{1,2}(Sender_Carrier))  % 如果这可用的消息发的出来
                    G_i(j) = 1;
                    
                else
                    G_i(j) = 0;
                  
                end
            end
            %G(j,Sender_Carrier) = 0;
            G(j,Carrier) = 0;
        end
    end
end