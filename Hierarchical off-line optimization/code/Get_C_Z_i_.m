function [C,Z] = Get_C_Z_i_(Carrier_i,A,S,Num_Of_Satellite,Carriers_Position,Satellite_Position)
% 根据动作和状态给出第i个载体的加权最小二乘估计的C，Z。C和Z的顺序都是先是观测部分，再是状态估计部分
    Sensor_Info = S{1,4};
    G = A{1,1};
    A_Estimation_Trans = A{1,2};
    [m,~] = size(G);
    [n,Num] = size(A_Estimation_Trans);
    X_Carrier_i = [];
    P_Carrier_i = [];
    temp1 = [];
    temp2 = cell(1,Num);
    C = [];
    Z = [];
    for j = 1:m
        if G(j,Carrier_i)==1
           [Sender_Carrier,~,~,If_Relative,Dimension,Sig_Square,Object] ...
                = Extract_Corresponding_Sensor_Info(j,Carrier_i,Sensor_Info);
           if If_Relative
               temp1 = eye(Dimension)*Sig_Square;
               C = blkdiag(C,temp1);
               temp2 = Get_Relative_Observation(Sender_Carrier,Object,Dimension,Sig_Square,Carriers_Position);
               Z = [Z;temp2];
           else
               temp2 = Get_Absolute_Observation(Sender_Carrier,Sig_Square,Carriers_Position,Satellite_Position);
               Z = [Z;temp2];
               temp1 = eye(length(temp2))*Sig_Square;
               C = blkdiag(C,temp1);
           end
        end
        temp2 = [];
    end
    for k = 1:Num  % 这边考虑已经存在在在载体上的状态估计
        temp1 = [];
        for jj = 1:n
            if ((~Is_Not_Own_Estimations(jj,k,Sensor_Info))...
                    + (A_Estimation_Trans(jj,Carrier_i)==1) == 2) % 状态估计是储存在载体k上的，且状态估计传输矩阵上确实要被表示为传输
                [~,~,Object] = Extract_Corresponding_Carrier(jj,Carrier_i,Num);
                temp1 = [temp1,Object];  % 这样可以找到全部载体K要向载体i传输的状态估计的载体的编号
            end
        end
        Sender_Carrier = k; Receivor_Carrier = Carrier_i;
        if ~isempty(temp1)
            for i = 1:length(temp1)
                z = S{1,2}{1,k}(:,temp1(1,i));
                Z = [Z;z];
            end
        end
        Cross_Covariance_Matrix_i = Get_Corresponding_Cross_Covariance_Matrix_i(Sender_Carrier,temp1,S);  % 找出载体k要向载体i传输怎样的互协方差矩阵
        C = blkdiag(C,Cross_Covariance_Matrix_i);
        temp2{1,k} = temp1;  % temp2存储每一个载体K向载体Carrier_i传输的状态估计的编号
    end
    temp3 = cell(1,Num);  %  temp3储存载体Carrier_i收到的各种状态估计中，每一种分别由那些载体k传来
    for k = 1:length(temp2)
        if ~isempty(temp2{1,k})
            for kk = 1:Num
                for kkk = 1:length(temp2{1,k})
                    if temp2{1,k}(1,kkk) == kk
                        temp3{1,kk} = [temp3{1,kk},k];
                    end
                end
            end
        end
    end
    C_ = C;
    for i = 1:length(temp3)  % 这边可能有些问题
        if (~isempty(temp3{1,i}))
            [X_Carrier_i,~] = Fusion_Estimations(temp3{1,i},S,i);  % 找出所有传给载体i的关于载体i的状态估计，并且进行最优融合
            for k = 1:length(temp3)
                if (~isempty(temp3{1,k})) && (k~=i)  % 剩下的不是自己的状态估计
                    [X,P] = Fusion_Estimations(temp3{1,k},S,k);  % 找出所有传给载体Carrier_i的关于载体k的状态估计，并且进行最优融合
                    C_ = Find_The_Position_Of_Certain_SigSquare_And_Modification_(i,k,Carrier_i,C_,A,S,X,P,X_Carrier_i,Num_Of_Satellite);  % 改！找出所有在载体Carrier_i上的和i有关的相对观测的sigsquare在C矩阵中的位置并且进行相应修改
                end
            end
        end
    end
    C = C_;
end