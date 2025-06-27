function G = Build_Observation_Trans_Matrix(S)
% 建立一个空白的传感器信息传输矩阵，其中行是所有的传感器，列是载体
    [a,~] = size(S);
    add = 0;
    for i = 1:a
        [b,~] = size(S{i,1}{1,2});
        add = add + b;
    end
    G = zeros(add,a);
end