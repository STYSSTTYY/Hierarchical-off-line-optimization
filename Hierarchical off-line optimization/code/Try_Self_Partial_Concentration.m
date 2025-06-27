function [G_,X_,Relation_Map_,Observation_Map_,Select_Carrier_,Flag] = Try_Self_Partial_Concentration(State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier,RC_All_)
% 尝试用自己的GNSS信息解算(如果有的话)
    global Base;
    global Num_Of_Satellite;

    Sensor_Info = State{1,4};
    [a,Num] = size(G);
    G_ = zeros(a,Num);
    for i = 1:Num
        Select_Carrier(i) = i;
    end

    if ~isempty(RC_All_)
        F_RC = 1;
    else
        F_RC = 0;
        RC_All_ = cell(Num,1);
    end

    % 每个载体解算自己的信息
    Rows = cell(Num,2);
    Rows_Com = cell(Num,3);
    for Row = 1:a
        [Sender_Carrier,~,~,If_Relative,Dimension,~,~] ...
            = Extract_Corresponding_Sensor_Info(Row,1,Sensor_Info);
        Rows{Sender_Carrier,1} = [Rows{Sender_Carrier,1},Row];
        if If_Relative
            W = Base*Dimension;
        else
            W = Base*Num_Of_Satellite;
        end
        Rows_Com{Sender_Carrier,1} = [Rows_Com{Sender_Carrier,1},W];
        if ~If_Relative
            if Relation_Map(Sender_Carrier,Sender_Carrier)~=-1
                G_(Row,Sender_Carrier) = 1;
            end
        end
    end

    % 判断每一个载体最多可以输出哪些信息
    for i = 1:Num
        Max_Com = S_Final{1,3}{1,2}(1,i) - 12*Base*(nansum(S_Final{1,2}(:,i)));  % 必须要保留接收自己需要的所有信息的资源
        Rows{i,2} = 0;
        if (~isempty(Rows_Com{i,1}))&&(~isempty(Rows{i,1}))
            [x, fval] = Max_Out_Mes(Rows_Com{i,1},Max_Com);
            Rows{i,1}(x==0)=0;
        end
        Rows_Com{i,2} = fix(Max_Com/fval);
        Rows_Com{i,3} = fval;
    end

    % 需要局部集中式的再加入信息
    RC_Com = cell(Num,2);
    for i = 1:Num
        Flags = zeros(Num,1);
        if (F_RC==1)&&(~isempty(RC_All_{i,1}))
            RC_Com{i,2} = S_Final{1,3}{1,2}(1,i) - 12*Base*(nansum(S_Final{1,2}(:,i)));  % 必须要保留接收自己需要的所有信息的资源
            RC_Now = RC_All_{i,1};
            for Row = 1:a
                [Sender_Carrier,~,~,~,~,~,~] ...
                    = Extract_Corresponding_Sensor_Info(Row,1,Sensor_Info);
                if (ismember(Sender_Carrier,RC_Now))&&(ismember(Row,Rows{Sender_Carrier,1}))&&(Rows{Sender_Carrier,2}<Rows_Com{Sender_Carrier,2})
                    if Relation_Map(Sender_Carrier,Sender_Carrier)~=-1
                        G_(Row,i) = 1;
                        Flags(Sender_Carrier) = Flags(Sender_Carrier) + 1;
                        if Flags(Sender_Carrier)==1
                            Rows{Sender_Carrier,2} = Rows{Sender_Carrier,2}+1;
                        end
                    end
                end    
            end
            RC_Com{i,1} = Rows_Com{i,3};
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

    % 分析计算通讯需求
    Temp3 = [];
    Com = Com_Cost(A,State);  % 计算该步传输的通讯代价
    for i = 1:Num
        if (F_RC==1)&&(~isempty(RC_All_{i,1}))&&(Com(1,i) >= (S_Final{1,3}{1,2}(1,i) - 12*Base*(nansum(S_Final{1,2}(:,i)))))
            Temp3 = [Temp3,i];
            Select_Carrier(i) = i;  % 第一步就通讯不足(但是默认为i) 
        end
    end

    % 算力不达标的标记，这次不算了，在A中抹除
    RC_used = [];
    if ~isempty(Temp2)
        G = A{1,1};
        X = A{1,2};
        for i = 1:length(Temp2)
            if ~isempty(RC_All_{Temp2(i),1})  % 如果是局部集中式的算力不足了
                for kk = 1:Num
                    if ~ismember(kk,[Temp2,Temp3,RC_used])
                        if (S_Final{1,3}{1,1}(1,kk)>(Cal(Temp2(i))+Cal(kk)))&&(S_Final{1,3}{1,2}(1,kk)>(Com(Temp2(i))+Com(kk)))
                            RC_used = [RC_used,kk];
                            Select_Carrier(Temp2(i)) = kk;
                            break;
                        end
                    end
                end
                G(G(:,Temp2(i))==1) = 1;
                G(:,Temp2(i)) = zeros(a,1);
            else
                G(:,Temp2(i)) = zeros(a,1);
                if Relation_Map(Temp2(i),Temp2(i))~=inf
                    Relation_Map(Temp2(i),Temp2(i)) = -1;  % 算力不足
                end
            end
        end
        A{1,1} = G;  
        A{1,2} = X;  % 第一步时根本就没有可以传输的状态估计。
        A{1,3} = Generate_Carrier_Need_Calculating(G,X); 
    end

    % 通讯不达标的
    if ~isempty(Temp3)
        G = A{1,1};
        X = A{1,2};
        for i = 1:length(Temp3)
            for kk = 1:Num
                if ~ismember(kk,[Temp2,Temp3,RC_used])
                    if (S_Final{1,3}{1,1}(1,kk)>(Cal(Temp3(i))+Cal(kk)))&&(S_Final{1,3}{1,2}(1,kk)>(Com(Temp3(i))+Com(kk)))
                        RC_used = [RC_used,kk];
                        Select_Carrier(Temp3(i)) = kk;
                        break;
                    end
                end
            end
            G(G(:,Temp3(i))==1) = 1;
            G(:,Temp3(i)) = zeros(a,1);
        end
        A{1,1} = G;  
        A{1,2} = X;  % 第一步时根本就没有可以传输的状态估计。
        A{1,3} = Generate_Carrier_Need_Calculating(G,X);
    end

    if F_RC==1
        for i = 1:Num
            if ~isempty(RC_All_{i,1})
                RC_Now = RC_All_{i,1};
                for kk = 1:length(RC_Now)
                    Relation_Map(RC_Now(kk),i) = 4;
                end
            end
        end
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