function Data_Size = Data_Size_Cross_Covariance_Matrix__(Cross_Covariance_Matrix_i,Base)
% 计算要传输的互协方差矩阵的通信代价
    if isempty(Cross_Covariance_Matrix_i)
        Data_Size = 0;
        return;
    end
    [m,n] = size(Cross_Covariance_Matrix_i);
    Data_Size = m*n*Base;
end