function Flag = Check_If_Have_Multipath(Observation_Trans_Graph,Num,m)
% 检查有向图Observation_Trans_Graph是否存在多径，是1否0
    Flag = 0;
    G = digraph(Observation_Trans_Graph);
    [a,~] = size(Observation_Trans_Graph);
    for i = 1:Num
        for j = 1:m
            D = distances(G,j,a-Num+i);
            if ~isinf(D)
                paths = allpaths(G,j,a-Num+i,'MaxNumPaths',2);
                Flag = size(paths,1) > 1;
                if Flag
                    return;
                end
            end
        end
    end
end