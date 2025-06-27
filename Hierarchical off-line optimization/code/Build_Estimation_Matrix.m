function E = Build_Estimation_Matrix(S)
% 建立一个空白的状态估计矩阵，其中行是所有载体是否进行状态估计
    [a,~] = size(S);
    E = zeros(a,1);
end