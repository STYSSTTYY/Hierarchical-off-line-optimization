function FC_OK = Find_FC_OK(Num,Temp,Relation_Map,Select_Carrier)
    % 找出那些需要自己解算的状态估计全部达标且算力通讯有富裕的载体。
    Had_Finished = find(Temp==0);
    FC_OK = [];
    if isempty(Had_Finished)
        FC_OK = [];
        return;
    end
    for i = 1:Num  %遍历所有的载体
        Estimations = find(Select_Carrier(end,:)==i);
        if isempty(Estimations)  % 如果该载体不解算任何状态估计
            if Relation_Map(i,i)~=inf  % 完全不能结算的排除
                if Relation_Map(i,i)>0  % 既没有算力不足也没有通讯不足
                    FC_OK = [FC_OK,i];
                end
            end
        else
            T = ismember(Estimations,Had_Finished);  % 如果所有该载体负责的状态估计都达到要求了
            if all(T==1)
                if Relation_Map(i,i)~=inf  % 完全不能结算的排除
                    if Relation_Map(i,i)>0  % 既没有算力不足也没有通讯不足
                        FC_OK = [FC_OK,i];
                    end
                end
            end
        end
    end
end