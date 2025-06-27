function [x, fval] = Max_Out_Mes(weights,maxWeight)
% 载体最多能输出哪些信息
    
    % 定义整数线性规划问题
    f = -weights'; % 最小化总质量
    A = weights; % 总质量不超过上限
    b = maxWeight;
    intcon = 1:length(weights); % 整数规划变量
    lb = zeros(size(weights)); % 货物数量不能为负数
    ub = ones(size(weights)); % 货物数量要么是0要么是1
    options = optimoptions('intlinprog', 'Display', 'off');
    
    % 解决整数线性规划问题
    [x, fval, ~] = intlinprog(f, intcon, A, b, [], [], lb, ub, options);

    fval = -fval;
end