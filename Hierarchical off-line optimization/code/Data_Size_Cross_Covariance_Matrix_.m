function Data_Size = Data_Size_Cross_Covariance_Matrix_(Cross_Covariance_Matrix_i)
% 计算要传输的互协方差矩阵的通信代价，该函数专用于最后一步转移时的特殊情况的通讯量计算。
    global Base;
    if isempty(Cross_Covariance_Matrix_i)
        Data_Size = 0;
        return;
    end
    [m,~] = size(Cross_Covariance_Matrix_i);
    mm = fix(m / 3);
    Data_Size = mm*9*Base;
end