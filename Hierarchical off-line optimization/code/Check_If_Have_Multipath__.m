function Flag = Check_If_Have_Multipath__(Observation_Trans_Graph,Num,m)
% 检查有向图Observation_Trans_Graph是否存在多径，是1否0
    Flag = 0;
    
    [a,~] = size(Observation_Trans_Graph);
    for i = 1:Num
        for j = 1:m
            [~, moreThanOne] = CheckIfMultipath_(Observation_Trans_Graph,j,a -Num+i);
            Flag = moreThanOne;
            if Flag
                return;
            end
        end
    end
end