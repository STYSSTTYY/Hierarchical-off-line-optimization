function [X,P_] = Fusion_Estimations(temp3_i,S,i)
% 找出所有传给载体Carrier_i的关于载体i的状态估计，并且进行最优融合
    Carriers = temp3_i;
    H = [];
    P = [];
    Z = [];
    if length(temp3_i) == 1
        X = S{1,2}{1,Carriers(1,1)}(1:3,i);
        P_ = Get_Corresponding_Cross_Covariance_Matrix_i(Carriers(1,1),i,S);
        return;
    else
        x = zeros(3,length(Carriers));
        p = cell(1,length(Carriers));
        for k = 1:length(Carriers)
            x(1:3,k) = S{1,2}{1,Carriers(1,k)}(1:3,i);
            p{1,k} = Get_Corresponding_Cross_Covariance_Matrix_i(Carriers(1,k),i,S);
        end
        for k = 1:length(Carriers)
            H = [H;eye(3)];
            P = blkdiag(P,p{1,k});
            Z = [Z;x(1:3,k)];
        end
        temp = H'/P*H;
        temp_ = (temp\H')/P;
        X = temp_*Z;
        P_ = temp_*P*temp_';
    end
end