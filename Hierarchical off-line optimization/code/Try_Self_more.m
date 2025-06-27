function [G_,X_,Relation_Map_,Observation_Map_,Select_Carrier_,Flag,Flag_Central,Flag_Partial_Concentration,Restart_Concentration] = Try_Self_more(Temp,Estimations_Positions,A_Array,State,S_Final,G,X,Relation_Map,Observation_Map,Select_Carrier,If_Random,js)
% 尝试用自己的信息解算后尝试进一步融合
% Temp1储存了总的来看是哪些状态估计的精度没有达到要求。Temp上面是一个数组，代表这些不符合要求，不达标的是1，达标的是0
% Estimations_Positions是一个元胞，它一共有Num行，代表每一个载体的状态估计，元胞内存有一数组，代表这状态估计存在于哪些载体上
    Flag_Partial_Concentration = 0;
    Flag_Central = 0;
    Num = length(Temp);
    X_ = X;
    [a1,b1] = size(G);
    [a2,b2] = size(X);
    G_New = zeros(a1,b1);
    X_New = zeros(a2,b2);
    %Find_Cal_Lack
    %Which_had_Finished = Find_Which_had_Finished(Temp,State,S_Final,Relation_Map,Select_Carrier);  % 还没检验，找出哪些载体自身的状态估计已经符合要求的，且计算、通信有富余
    % Estimations_Positions是一个元胞，它一共有Num行，代表每一个载体的状态估计，元胞内存有一数组，代表这状态估计存在于哪些载体上
    Estimation_Had_not_Finished = find(Temp==1);  % 找出还没有满足精度要求的状态估计
    FC_OK = Find_FC_OK(Num,Temp,Relation_Map,Select_Carrier);  % 找出那些需要自己解算的状态估计全部达标且算力通讯有富裕的载体。
    FC_OK_ = FC_OK;
    if isempty(Select_Carrier) % 如果第一步什么都没法算出来
        return;
    end
    Select_Carrier_Temp = Select_Carrier(end,:);
    % 先处理上一步的遗留问题，优先用存在在别的载体上的状态估计加信息计算
    Had_Process = [];
    for i = 1:length(Estimation_Had_not_Finished)
        FC_Now = Select_Carrier_Temp(Estimation_Had_not_Finished(i));  %  看看上一步这玩意在哪里解算
        if FC_Now == -1
            FC_Now = Estimation_Had_not_Finished(i);  % 第一步算不出来还是默认自己
        end
        if ismember(FC_Now,Had_Process)  % 如果该载体已经被处理过了，跳过
            continue;
        end
        Flag_FC = Relation_Map(FC_Now,FC_Now);  % 看看当前状态有没有算力不足之类的问题
        if Flag_FC==inf
            continue;  % 如果该载体自身不可解算，跳过
        end
        if Flag_FC <0  % 如果该载体算力不足或者通信不足
            Estimations = find(Select_Carrier_Temp(end,:)==Select_Carrier_Temp(end,Estimation_Had_not_Finished(i)));  % 找到负责状态估计i的载体所有负责的状态估计
            [Locate,Locate_,Cal_Enough,Destination] = Find_Where_Precise(Num,Estimations,Estimations_Positions,Relation_Map,G,X,A_Array,State);  % 找出一定能传出来（通讯足够）的最精确的状态估计在哪个载体上Locate，找出一定能传出来（通讯足够且存在通信足够算力足够载体能接受该状态估计没有协方差未知）的最精确的状态估计在哪个载体上Locate_，平且判断其算力是否充足，是1否0
            for j = 1:length(Locate)
                if Cal_Enough(j)>0  % 如果存在精度最高且算力充足能通讯的载体
                    %  那直接改成Locate这个载体运算了
                    Select_Carrier_Temp(Estimations(j)) = Locate(j);%  更新Select_Carrier
                    Relation_Map = Refresh_All_Maps(Locate(j),Relation_Map,G,X,A_Array,State);  % 更新Relation_Map，重新评估各种观测和新的FC的关系 
                else  % 如果不存在
                    if Locate_(j)>0  % 如果存在精度最高且算力不充足但是能发送出去的载体
                        Select_Carrier_Temp(Estimations(j)) = Destination(j);
                        X_((Locate_(j)-1)*25+Estimations(j),Destination(j)) = 1;  % 发送给可接受的载体Destination(j)
                        Relation_Map = Refresh_All_Maps(Destination(j),Relation_Map,G,X,A_Array,State);  % 更新Relation_Map，重新评估各种观测和新的FC的关系 
                    else % 如果什么都不存在就保持现状
                        if js > 0  % 如果js>0，说明就剩下这些没有完成了，剩下的都是独立的，从FC_OK里面选一个合适的
                            [Dis,FC_OK_] = Choose_FC_OK(FC_OK,FC_OK_);  % 还没写，从FC_OK里面挑一个
                            Select_Carrier_Temp(Estimations(j)) = Dis;
                            Relation_Map = Refresh_All_Maps(Dis,Relation_Map,G,X,A_Array,State);  % 更新Relation_Map，重新评估各种观测和新的FC的关系 
                        end
                    end
                end
            end
        end
        Had_Process = [Had_Process,FC_Now];  % 记录已经检查果的载体，就不用重复了
    end

    % 后处理这一步的精度提升
    Had_Process = [];
    Alll = cell(Num,2);
    Restart_Concentration = cell(Num,1);
    for i = 1:length(Estimation_Had_not_Finished)
        FC_Now = Select_Carrier_Temp(Estimation_Had_not_Finished(i));  %  看看当前这玩意在哪里解算
        if FC_Now == -1
            FC_Now = Estimation_Had_not_Finished(i);  % 第一步算不出来还是默认自己
        end
        Flag_FC = Relation_Map(FC_Now,FC_Now);  % 看看当前状态有没有算力不足之类的，理论上是不会有了（除非上一步有一些保持原状的）
        if Flag_FC==inf
            continue;  % 如果该载体自身不可解算，跳过
        end
        if ismember(FC_Now,Had_Process)  % 如果该载体已经被处理过了，跳过
            continue;
        end
        if Flag_FC>0  %  如果一切正常，可以拿来解算
            Estimations = find(Select_Carrier_Temp(end,:)==Select_Carrier_Temp(end,Estimation_Had_not_Finished(i)));  % 找到负责状态估计i的载体所有负责的状态估计
            Estimations = Estimations(ismember(Estimations,Estimation_Had_not_Finished)==1);
            [Carriers_Had_Used,Relation_Map] = Which_Carrier_Had_Used(Num,FC_Now,Relation_Map,G,X_,A_Array,State,S_Final);  % 找出那些载体的信息已经被全部使用了     
            [~,Estimation_Around_Saper,Flag_EA,Relation4] = Find_Estimation_Around(Num,FC_Now,Estimations,Carriers_Had_Used,Observation_Map,Relation_Map);  % 找出这一轮动作中，需要向Flag_FC加入那些载体的信息
            % 这边还要加一个局部集中式的判断
            [G_,X_,Relation_Map,Observation_Map,Select_Carrier_Temp,RC,fpc] = Decide_G_X(FC_Now,Estimations,Estimation_Around_Saper,Relation4,Flag_EA,Relation_Map,Observation_Map,Select_Carrier_Temp,G,X_,A_Array,State,S_Final,Carriers_Had_Used);  % 定下来需要传输的信息并修改相应的矩阵
            if fpc==1
                Flag_Partial_Concentration = 1;
            end
            Restart_Concentration{FC_Now,1} = RC;
            EAS_L = length(Estimation_Around_Saper);
            if EAS_L~=0
                for o = 1:EAS_L
                    if isempty(Estimation_Around_Saper{o})
                        Flag_Central = 1;
                    end
                end
            end
            Alll{FC_Now,1} = G_;
            G_New(:,FC_Now) = G_(:,FC_Now);
            Alll{FC_Now,2} = X_;
            X_New(:,FC_Now) = X_(:,FC_Now);
        end
        Had_Process = [Had_Process,FC_Now];  % 记录已经检查果的载体，就不用重复了
    end
    if (all(G_New(:)==0))&&(all(X_New(:)==0))
        Flag = 0;
        Select_Carrier_Temp = [];
    else
        Flag = 1;
    end
    G_ = G_New;
    X_ = X_New;
    Relation_Map_ = Relation_Map;
    Observation_Map_ = Observation_Map;
    Select_Carrier_ = [Select_Carrier;Select_Carrier_Temp];
end