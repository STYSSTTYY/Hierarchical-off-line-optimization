function P_All= Extract_Performance_Of_State(S)
% 从当前状态中提取出所有载体上的互协方差矩阵
    Num = length(S);
    P_All = cell(1,Num);
    for i = 1:Num
        P_All{1,i} = S{1,i};
    end
end