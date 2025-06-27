function [Flag,Delta_X] = Solve_Delta_X_WLSE(Delta_Z,H_New,C)
% 通过加权最小二乘估计计算每一次迭代后最新的Delta_X,并且给出判断是否有解。Flag=1有解，Flag=0无解
    Flag = 1;
    if isempty(H_New)
        Flag = 0;
        Delta_X = [];
        return;
    end
    D = length(Delta_Z);
    if (det(C) ~= 0) || (rank(C)==D)
        Flag = 1;
    else
        Flag = 0;
        Delta_X = [];
        return;
    end
    temp1 = H_New'/C;
    temp1 = temp1*H_New;
    temp2 = H_New'/C;
    if det(temp1) ~= 0 || (rank(C)==D)
        Flag = 1;
    else
        Flag = 0;
        Delta_X = [];
        return;
    end
    temp3 = temp1\temp2;
    temp3 = temp3*Delta_Z;
    Delta_X = temp3;
end