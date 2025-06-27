function Cost = Computation_Operand(Size_H,Size_P,Size_Z,Size_X)
% 根据输入的H,P,Z,X矩阵的尺寸，计算理论上解算所需要的运算量，默认解算状态估计时，加权最小二乘估计只进行一次迭代（这边可以修改）
    Iteration = 1;  % 默认解算状态估计时，加权最小二乘估计只进行一次迭代（这边可以修改）
    Cost = 0;
    Temp1 = Size_H(1,1) * Size_H(1,2);  % H转置的运算量
    Temp2 = (1/3)*(Size_P(1,1))^3 + 2*(Size_P(1,1))^2;  % W=inv(p)的运算量，参考Cholesky factorization法
    Temp3 = Temp1 + Temp2 + Size_H(1,2)*Size_H(1,1)*(2*Size_H(1,1)-1); % H'W运算量
    Temp4 = Temp3 + Size_H(1,2)*Size_H(1,2)*(2*Size_H(1,1)-1) + (1/3)*(Size_H(1,2))^3 + 2*(Size_H(1,2))^2;  % inv(H'WH)运算量
    Cost_Estimation = Temp4 + Size_H(1,2)*Size_H(1,1)*(2*Size_H(1,2)-1) + Size_H(1,2)*Size_Z(1,2)*(2*Size_Z(1,1)-1);  % inv(H'WH)H'WZ运算量
    Cost_Estimation = Cost_Estimation * Iteration;
    Cost_Cx = Size_H(1,1)*Size_H(1,2) + Size_H(1,2)*Size_H(1,1)*(2*Size_H(1,1)-1) + Size_H(1,2)*Size_H(1,2)*(2*Size_H(1,1)-1);  % Cx的运算量
    % 这里先算H'W运算量，由此得到inv(H'WH)运算量，由于H'W已经算过，所以inv(H'WH)H'W运算量只要inv(H'WH)运算量额外加上两个矩阵相乘的运算量
    % 所以inv(H'WH)H'WZ运算量就是inv(H'WH)运算量额外加上两个矩阵相乘的运算量
    %由于inv(H'WH)H'W已经算过，所以S=inv(H'WH)H'W没有运算量，SCS'就是S转置的运算量和三个矩阵相乘的运算量
    Cost = Cost + Cost_Cx + Cost_Estimation;
end