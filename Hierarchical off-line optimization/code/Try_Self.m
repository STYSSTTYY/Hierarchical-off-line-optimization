function [G_,X_,Relation_Map_,Observation_Map_,Select_Carrier_,Flag] = Try_Self(State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier)
% 尝试用自己的GNSS信息解算(如果有的话)
    Sensor_Info = State{1,4};
    [a,Num] = size(G);
    G_ = zeros(a,Num);
    for i = 1:Num
        Select_Carrier(i) = i;
    end

    % 每个载体解算自己的信息
    for Row = 1:a
        [Sender_Carrier,~,~,If_Relative,~,~,~] ...
            = Extract_Corresponding_Sensor_Info(Row,1,Sensor_Info);
        if ~If_Relative
            if Relation_Map(Sender_Carrier,Sender_Carrier)~=-1
                G_(Row,Sender_Carrier) = 1;
            end
        end
    end

    % 把当前没有用的信息排除
    A{1,1} = G_;  
    A{1,2} = X;  % 第一步时根本就没有可以传输的状态估计。
    E = Generate_Carrier_Need_Calculating(G_,X); 
    A{1,3} = E;
    for i = 1:Num
        [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S(i,A,State);
        if (E(i)==1) && (Flag2==1)
            [A,~,~]= Eliminate_Carrier_Cant_Solved(Carriers_Number,X_Carrier_Number_All,i,A,State);
            if Relation_Map(i,i)~=inf
                Relation_Map(i,i) = 2;
            end
        end
    end

    % 分析计算算力需求
    Temp2 = [];
    Cal = Cal_Cost(A,State);  % 计算该步传输的算力代价
    for i = 1:Num
        if (~(Cal(1,i)<S_Final{1,3}{1,1}(1,i))) && (~(Cal(1,i)==S_Final{1,3}{1,1}(1,i)))
            Temp2 = [Temp2,i];
            Select_Carrier(i) = i;  % 第一步就算力不足的就没有载体计算相应状态估计了(但是默认为i) 
        end
    end

    % 算力不达标的标记，这次不算了，在A中抹除
    if ~isempty(Temp2)
        G = A{1,1};
        X = A{1,2};
        for i = 1:length(Temp2)
            G(:,Temp2(i)) = zeros(a,1);
            if Relation_Map(Temp2(i),Temp2(i))~=inf
                Relation_Map(Temp2(i),Temp2(i)) = -1;  % 算力不足
            end
        end
        A{1,1} = G;  
        A{1,2} = X;  % 第一步时根本就没有可以传输的状态估计。
        A{1,3} = Generate_Carrier_Need_Calculating(G,X); 
    end

    % 最后进行检验，如果这个动作不是空的，则Flag=1，若是空的，则则Flag=0
    if all(E==0)
        Flag = 0;
    else
        Flag = 1;
    end
    G_ = A{1,1};
    X_ = A{1,2};
    Relation_Map_ = Relation_Map;
    Observation_Map_ = Observation_Map;
    Select_Carrier_ = Select_Carrier;
    if ~Flag
        Select_Carrier_ = [];
    end
end