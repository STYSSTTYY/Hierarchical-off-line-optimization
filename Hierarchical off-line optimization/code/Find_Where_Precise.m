function [Locate,Locate_,Cal_Enough,Destination] = Find_Where_Precise(Num,Estimations,Estimations_Positions,Relation_Map,G,X,A_Array,State)
% 找出一定能传出来（通讯足够）的最精确的状态估计在哪个载体上Locate，找出一定能传出来（通讯足够且存在载体能接受该状态估计没有协方差未知）的最精确的状态估计在哪个载体上Locate_，平且判断其算力是否充足，是1否0
% Estimations_Positions是一个元胞，它一共有Num行，代表每一个载体的状态估计，元胞内存有一数组，代表这状态估计存在于哪些载体上    
    global Num_Of_Satellite;
    Locate = [];
    Locate_ = [];
    Cal_Enough = [];
    Destination = [];
    if isempty(Estimations)
        Locate = [];
        Locate_ = [];
        Cal_Enough = 0;
        Destination = 0;
        return;
    end
    P_All = Extract_Performance_Of_State(State{1,1});
    for i = length(Estimations)
        Positions = Estimations_Positions{Estimations(i),1};
        if (isempty(Positions)) % 如果个状态估计还没有存在于系统内
            Locate = [Locate,0];
            Locate_ = [Locate_,0];
            Cal_Enough = [Cal_Enough,0];
            Destination = [Destination,0];
            continue;
        else  % 如果这个状态估计存在于系统内
            Precision = zeros(1,length(Positions));
            for j = 1:length(Positions)
                P_j = P_All{1,j};
                Precision(1,j) = trace(P_j(Estimations(i)*3-2:Estimations(i)*3,Estimations(i)*3-2:Estimations(i)*3));  % 相应载体上相应状态估计的精度
                if isnan(Precision(1,j))
                    Precision(1,j) = inf;
                end
            end
            [~, ~, ranks] = unique(Precision);

            % 判断一
            for j = 1:max(ranks)
                Number = find(ranks==j);
                Satisfy = 0;
                for k = 1:length(Number)
                    Carrier = Positions(Number(k));
                    if (Relation_Map(Carrier,Carrier) > 0) % 如果能够通讯与运算
                        Locate = [Locate,Carrier];
                        Cal_Enough = [Cal_Enough,1];
                        Satisfy = 1;
                        break;
                    end
                end
                if ~Satisfy
                    Locate = [Locate,0];
                    Cal_Enough = [Cal_Enough,0];
                end
            end

            % 判断二
            for j = 1:max(ranks)
                Number = find(ranks==j);
                Satisfy_ = 0;
                for k = 1:length(Number)
                    Carrier = Positions(Number(k));
                    if (Relation_Map(Carrier,Carrier)==-1) % 如果能够通讯但不能计算
                        A_New = cell(1,3);
                        A_New{1,1} = G;
                        A_New{1,2} = X;
                        kk = 1;
                        Satisfy = 0;
                        while true
                            if kk~=Carrier
                                for kkk = 1:length(Estimations)
                                    A_New{1,2}((Carrier-1)*25+Estimations(i),kk) = 1;
                                end
                                A_New{1,3} = Generate_Carrier_Need_Calculating(A_New{1,1},A_New{1,2});
                                if Check_If_No_Unknown_Cross_Covariance_last(A_New,A_Array,State,Num_Of_Satellite)
                                    Satisfy = 1;
                                    break;
                                else
                                    A_New{1,2}((Carrier-1)*25+Estimations(i),kk) = 0;
                                end
                            end
                            kk = kk+1;
                            if kk>Num
                                break;
                            end
                        end
                        if Satisfy
                            Locate_ = [Locate_,Carrier];
                            Destination = [Destination,kk];
                            Satisfy_ = 1;
                            break;
                        end
                    end
                end
                if ~Satisfy_
                    Locate_ = [Locate_,0];
                    Destination = [Destination,0];
                end
            end
        end
    end
end