function G_i = Gather_All_Available_Observations_i(i,Carrier,G,X,A_Array,S,S_Final)
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
            = Extract_Corresponding_Sensor_Info(i,Carrier,Sensor_Info);
        if (Sender_Carrier==i)&&(G(j,Carrier) ~= 1) % 如果是载体i上的观测
            G(j,Carrier) = 1;
            A_New = cell(1,3);
            A_New{1,1} = G;  
            A_New{1,2} = X;  % 组合成一个新的A
            A_New{1,3} = Generate_Carrier_Need_Calculating(G,X); 
            if ~Check_If_No_Unknown_Cross_Covariance(A_New,A_Array,S)
                G_i(j) = 0;
            else
                Cost_Com_G = Data_Size_(If_Relative,Dimension,Num_Of_Satellite,1,Base) + Com_Require(i);
                if ((Cost_Com_G + S{1,3}{1,2}(i)) <= S_Final{1,3}{1,2}(i))  % 如果这可用的消息发的出来
                    G_i(j) = 1;
                else
                    G_i(j) = 0;
                end
            end
            %G(j,i) = 0;
            G(j,Carrier) = 0;
            if (Sender_Carrier>i)
                break;
            end
        end
    end
end