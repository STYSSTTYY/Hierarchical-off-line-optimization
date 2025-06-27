function Which_had_Finished_ = Find_Which_had_Finished(Temp,State,S_Final,Relation_Map,Select_Carrier)
% 找出哪些载体上计算的所有状态估计已经符合要求的，且计算、通信有富余
    global Base;
    Had_Finished = find(Temp==0);  % 找出符合要求的状态估计
    Which_had_Finished = [];
    if isempty(Had_Finished)
        Which_had_Finished = [];
        return;
    end
    for i = 1:length(Temp)
        if Relation_Map(i,i)>0 % 首先这个载体要计算能力充足
            Flag = 1;
            for j = 1:Num
                if ismember(i,Select_Carrier(:,j))
                    if ~ismember(j,Had_Finished)
                        Flag = 0;
                        break;
                    end
                end
            end
            if Flag
                Which_had_Finished = [Which_had_Finished,i];
            end
        end
    end
    Estimations = State{1,2};
    Which_had_Finished_ = [];
    if ~isempty(Which_had_Finished)
        for i = 1:length(Which_had_Finished)
            X = The_Estimations_On_Carrier_i(Estimations{1,i});
            X = X(:,1);
            Com = Base*length(X)*12;
            if State{1,3}{1,2}(1,Which_had_Finished(i))+Com<=S_Final{1,3}{1,2}(1,Which_had_Finished{i})
                Which_had_Finished_ = [Which_had_Finished_,Which_had_Finished(i)];
            end
        end
    end
end