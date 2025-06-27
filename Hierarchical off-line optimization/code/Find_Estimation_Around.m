function [Estimation_Around,Estimation_Around_Saper,Flag_EA,Relation4] = Find_Estimation_Around(Num,Carrier,Estimations,Carriers_Had_Used,Observation_Map,Relation_Map)  
% 还没写，找出这一轮动作中，需要向Flag_FC加入那些载体的信息
    Flag_EA = 1;
    Estimation_Around = [];
    Relation4 = cell(length(Estimations),1);
    Estimation_Around_Saper = cell(length(Estimations),1);
    
    ObservationMatrix = zeros(Num, Num);
    % 使用 cellfun 判断元胞是否为空，返回一个与元胞矩阵同样大小的逻辑矩阵
    isEmptyCell = cellfun(@isempty, Observation_Map);
    % 若元胞为空，将输出矩阵对应位置设为0，否则设为1
    ObservationMatrix(~isEmptyCell) = 1;

%     ObservationMatrix = false(Num); % 使用逻辑值false进行预分配
%     ObservationMatrix = cellfun(@(x) ~(isempty(x) || (isnumeric(x) && x == 0)), Observation_Map);
    undirectedAdjMatrix = ObservationMatrix | ObservationMatrix';
    ObservationMatrix = undirectedAdjMatrix - diag(diag(undirectedAdjMatrix));
    for i = 1:length(Estimations)
        n = 1;  % 从最近的一圈开始
        startNode = Estimations(i);
        while true
            distanceNnodes = Find_distanceNnodes(ObservationMatrix,n,startNode);
            result = all(ismember(distanceNnodes, Carriers_Had_Used));
            if ~isempty(distanceNnodes)
                for j = 1:length(distanceNnodes)
                    if Relation_Map(distanceNnodes(j),Carrier) == 4
                        Relation4{i,1} = [Relation4{i,1},distanceNnodes(j)];
                    end
                end
            end
            if result
                n = n+1;
            else
                break;
            end
            if isempty(distanceNnodes)
                break;
            end
        end
        Estimation_Around_Saper{i,1} = setdiff(distanceNnodes, Carriers_Had_Used);
        Estimation_Around = [Estimation_Around,setdiff(distanceNnodes, Carriers_Had_Used)];
    end
    Estimation_Around = sort(unique(Estimation_Around));
    for i = 1:length(Estimations)
        if ~isempty(Relation4{i,1})
            Relation4{i,1} = sort(unique(Relation4{i,1}));
        end
    end
    if isempty(Estimation_Around)
        Flag_EA = 0;  % 如果再没有多余的信息可以使用，则返回0考虑集中式
    end   
end