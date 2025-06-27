function X_i = Gather_All_Available_Estimations_i(i,Carrier,G,X,A_Array,State,S_Final)
% 在X_i中记录所有载体i的可以放到载体Carrier来的状态估计
    global Base;
    Estimations = State{1,2};
    Estimations_Required = S_Final{1,2};
    Estimations_Required(isnan(Estimations_Required)) = 0;
    Com_Require = (sum(Estimations_Required)+1)*Base*12;  % 一定要留足所有状态估计传进来的资源外加把自己传出去的资源
    [n,m] = size(X);
    X_Reference = Get_Estimations_Last_Step_Est(Carrier,m,X,State);
    X_i = zeros(n,1);
    X = X_Reference;
    Estimations_On_i = {};
    for k = 1:m
        temp = The_Estimations_On_Carrier_i(Estimations{1,k});
        if isempty(temp)
            temp = [];
        else
            temp = temp(:,1);
            temp = temp';
        end
        Estimations_On_i(end+1,:) = {temp};
    end
    for j = 1:n  
        Carrier_Number = fix((j-1)/m) + 1;
        Estimation_Number = rem(j-1,m) + 1;
        if (Estimation_Number == i)   % 如果该状态估计是i的状态估计且不在载体Carrier上
            if ismember(Estimation_Number,Estimations_On_i{Carrier_Number,1})  % 如果在指定载体k上确实存在该状态估计的话
                X(j,Carrier) = 1;
                A_New = cell(1,3);
                A_New{1,1} = G;  
                A_New{1,2} = X;  % 组合成一个新的A
                A_New{1,3} = Generate_Carrier_Need_Calculating(G,X); 
                if ~Check_If_No_Unknown_Cross_Covariance(A_New,A_Array,State)
                    X_i(j) = 0;
                else
                    Cost_Com_G = Com_Require(Carrier_Number);
                    if ((Cost_Com_G + State{1,3}{1,2}(Carrier_Number)) <= S_Final{1,3}{1,2}(Carrier_Number))  % 如果这可用的消息发的出来
                        X_i(j) = 1;
                    else
                        X_i(j) = 0;
                    end
                end
                X(j,Carrier) = 0;
            end 
        end
        if X_Reference(j,i) == 1
            X(j,i) = 1;  % 假设的就是每一轮每个载体上的状态估计进入下一轮解算，所以对应的X元素必须为1
        end
    end
end