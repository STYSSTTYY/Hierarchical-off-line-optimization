function [exists, moreThanOne] = CheckIfMultipath_(adjMatrix, nodeA, nodeB)
    % 该函数接受一个邻接矩阵 adjMatrix 和两个节点 nodeA 与 nodeB
    % 返回两个值：exists 表示至少存在一条路径，moreThanOne 表示是否存在多于一条路径
    
    % 初始化变量
    n = size(adjMatrix, 1); % 节点的数量
    visited = zeros(n, 1); % 访问过的节点
    queue = []; % BFS 队列
    foundPaths = 0; % 找到的路径数量
    
    % 将起始节点添加到队列
    queue(end+1) = nodeA; 
    
    % 进行 BFS
    while ~isempty(queue)
        currentNode = queue(1);
        queue(1) = []; % 出队
        visited(currentNode) = 1; % 标记为访问过
        
        if currentNode == nodeB
            foundPaths = foundPaths + 1; % 找到一条路径
            if foundPaths > 1
                break; % 如果找到多于一条路径则退出
            end
        end
        
        % 遍历所有邻居
        for i = 1:n
            if adjMatrix(currentNode, i) == 1 && visited(i) == 0
                queue(end+1) = i; % 入队
            end
        end
    end
    
    % 根据找到的路径数量设置返回值
    exists = (foundPaths > 0);
    moreThanOne = (foundPaths > 1);
end
