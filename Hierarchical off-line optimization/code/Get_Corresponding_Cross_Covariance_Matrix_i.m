function Cross_Covariance_Matrix_i = Get_Corresponding_Cross_Covariance_Matrix_i(Sender_Carrier,temp1,S)
% 找出载体Sender_Carrier要向载体i传输怎样的互协方差矩阵
    if isempty(temp1)
        Cross_Covariance_Matrix_i = [];
        return;
    end
    State_Covariance_Matrix = S{1,1}{1,Sender_Carrier};
    Cross_Covariance_Matrix_i_ = [];
    Cross_Covariance_Matrix_i = [];
    for i = 1:length(temp1)
        Cross_Covariance_Matrix_i_ = [Cross_Covariance_Matrix_i_,State_Covariance_Matrix(:,((temp1(1,i)-1)*3+1):(temp1(1,i))*3)];
    end
    for i = 1:length(temp1)
        Cross_Covariance_Matrix_i = [Cross_Covariance_Matrix_i;Cross_Covariance_Matrix_i_(((temp1(1,i)-1)*3+1):(temp1(1,i))*3,:)];
    end
end