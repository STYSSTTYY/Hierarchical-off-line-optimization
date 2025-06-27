function X = Build_Estimation_Trans_Matrix(S)
% 建立一个空白的状态估计传输矩阵，其中行是所有载体可能存有的状态估计，列是载体
    [a,~] = size(S);
    X = zeros(a*a,a);
end