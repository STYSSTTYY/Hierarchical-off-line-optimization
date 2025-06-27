function Data_Size = Data_Size_Cross_Covariance_Matrix(Cross_Covariance_Matrix_i)
% 计算要传输的互协方差矩阵的通信代价
    global Base;
    if isempty(Cross_Covariance_Matrix_i)
        Data_Size = 0;
        return;
    end
    [m,n] = size(Cross_Covariance_Matrix_i);
    Data_Size = m*n*Base;
end