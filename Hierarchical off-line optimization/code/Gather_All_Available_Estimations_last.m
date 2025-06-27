function X_ = Gather_All_Available_Estimations_last(i,G,X,A_Array,State,Num_Of_Satellite)
% 根据载体状态和历史动作，将剩下的别的载体的状态估计中能用的都汇聚到某个载体上来，虽然我觉得应该没了
    Estimations = State{1,2};
    [n,m] = size(X);
    X_Reference = X;
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
    for j = 1:n  % 这里的状态估计是按顺序一个个尝试的，但是事实上很有可能出现几个状态估计互斥的情况，具体选哪个更优其实需要判断，而这里就直接从上到下了
        Carrier_Number = fix((j-1)/m) + 1;
        Estimation_Number = rem(j-1,m) + 1;
        if ismember(Estimation_Number,Estimations_On_i{Carrier_Number,1})  % 如果在指定载体k上确实存在该状态估计的话
            
            X(j,i) = 1;
            A_New = cell(1,3);
            A_New{1,1} = G;  
            A_New{1,2} = X;  % 组合成一个新的A
            A_New{1,3} = Generate_Carrier_Need_Calculating(G,X); 
            
            if ~Check_If_No_Unknown_Cross_Covariance_last(A_New,A_Array,State,Num_Of_Satellite)
                X(j,i) = 0;
            end
  
            if X_Reference(j,i) == 1
                X(j,i) = 1;  % 假设的就是每一轮每个载体上的状态估计进入下一轮解算，所以对应的X元素必须为1
            end
            
        end 
    end
    X_ = X;
end