function distanceNnodes = Find_distanceNnodes(ObservationMatrix,n,startNode)
%找到距离指定点指定距离的节点
    
    % 初始化
    currentNodes = startNode; % 当前节点集合
    visited = false(1,size(ObservationMatrix,1)); % 已访问的节点
    visited(currentNodes) = true;
    
    % 迭代n次
    for k = 1:n
        % 找到从当前节点集合出发的所有节点
        nextNodes = any(ObservationMatrix(currentNodes, :), 1);
        % 更新当前节点集合，并排除已访问的节点
        currentNodes = find((nextNodes)&(~visited));
        visited(currentNodes) = true;
        
        % 如果没有新节点，提前终止循环
        if isempty(currentNodes)
            break;
        end
    end
    
    % 输出结果
    distanceNnodes = currentNodes;
end