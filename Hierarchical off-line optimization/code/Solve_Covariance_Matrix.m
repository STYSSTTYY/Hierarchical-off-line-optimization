function [Flag,S_] = Solve_Covariance_Matrix(H_New,C)
% 最后计算协方差
    Flag = 1;
    [m,~] = size(H_New);
    if (det(C) ~= 0) || (rank(C)==m)
        Flag = 1;
    else
        Flag = 0;
        S_ = [];
        return;
    end
    temp1 = H_New'/C;
    temp1 = temp1*H_New;
    temp2 = H_New'/C;
    if det(temp1) ~= 0
        Flag = 1;
    else
        Flag = 0;
        Delta_X = [];
        return;
    end
    temp3 = temp1\temp2;
    temp4 = temp3*C*temp3';
    S_ = temp4;
end