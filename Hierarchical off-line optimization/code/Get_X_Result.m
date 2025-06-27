function X_Result = Get_X_Result(Receiver_X,Temp,S_,j)
% 按格式给出载体j向载体i传输的状态估计
    [a,Num] = size(Receiver_X);
    X_Result = ones(a,Num)*NaN;
    k = length(Temp);
    X_All = S_{1,2}{1,j};
    for u = 1:k
        Select = Temp(1,u);
        X_Result(:,Select) = X_All(:,Select);
    end
end