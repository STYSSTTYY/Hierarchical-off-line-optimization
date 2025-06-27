function H_New = Get_H_New_(Carrier_i,A,S,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,H_,Num_Of_Satellite,Satellite_Position)
% 获取每一次迭代时最新的H
    C = 299792458;
    Sensor_Info = S{1,4};
    G = A{1,1};
    A_Estimation_Trans = A{1,2};
    [m,~] = size(G);
    [n,Num] = size(A_Estimation_Trans);
    temp2 = 1;
    if isempty(X_Carrier_Number_All)
        H_New = [];
        return;
    end
    for j = 1:m
        if G(j,Carrier_i)==1
            [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
                 = Extract_Corresponding_Sensor_Info(j,Carrier_i,Sensor_Info);
            D = Get_Denominator_(Sender_Carrier,If_Relative,Dimension,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,Num_Of_Satellite,Satellite_Position);  % 改！获取每一轮迭代时对应项的分母
            if If_Relative
                if Dimension == 1
                    [X_Of_Sender_Carrier,X_Of_Object] = ...
                        Extract_X_From_X_New(Sender_Carrier,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 从X_New中提取对应的X(3D)
                    h = (X_Of_Object - X_Of_Sender_Carrier)/D;
                    h = h';
                    [Bottom,Top] = Find_The_Row_Position_Of_H__(Carrier_i,j,A,S,Num_Of_Satellite);  % 改！根据传感器编号估计其在H矩阵中的行的位置
                    for i = Bottom:1:Top
                        [Left,Right] = Find_The_Column_Position_Of_H(Sender_Carrier,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 根据载体编号估计其在H矩阵中的列的位置
                        if (Right - Left) == 3
                            Right = Right - 1;
                        end
                        for ii = Left:1:Right
                            H_(i,ii) = -h(1,temp2);
                            temp2 = temp2 + 1;
                        end
                        temp2 = 1;
                        [Left,Right] = Find_The_Column_Position_Of_H(Object,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 根据载体编号估计其在H矩阵中的列的位置
                        if (Right - Left) == 3
                            Right = Right - 1;
                        end
                        for ii = Left:1:Right
                            H_(i,ii) = h(1,temp2);
                            temp2 = temp2 + 1;
                        end
                        temp2 = 1;
                    end
                elseif Dimension == 3
                    [X_Of_Sender_Carrier,X_Of_Object] = ...
                        Extract_X_From_X_New(Sender_Carrier,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 从X_New中提取对应的X(3D)
                    h = (X_Of_Object - X_Of_Sender_Carrier);
                    h = h';
                    [Bottom,Top] = Find_The_Row_Position_Of_H__(Carrier_i,j,A,S,Num_Of_Satellite);  % 改！根据传感器编号估计其在H矩阵中的行的位置
                    [Left,Right] = Find_The_Column_Position_Of_H(Sender_Carrier,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 根据载体编号估计其在H矩阵中的列的位置
                    if (Right - Left) == 3
                        Right = Right - 1;
                    end
                    for i = 0:2
                        H_(Bottom+i,Left+i) = -h(1,i+1)/D(i+1,1);
                    end
                    [Left,Right] = Find_The_Column_Position_Of_H(Object,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 根据载体编号估计其在H矩阵中的列的位置
                    if (Right - Left) == 3
                        Right = Right - 1;
                    end
                    for i = 0:2
                        H_(Bottom+i,Left+i) = h(1,i+1)/D(i+1,1);
                    end
                end
            else
                X_Of_Sender_Carrier = Extract_X4_From_X_New(Sender_Carrier,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);
                [Left,Right] = Find_The_Column_Position_Of_H(Sender_Carrier,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 根据载体编号估计其在H矩阵中的列的位置
                [Bottom,Top] = Find_The_Row_Position_Of_H__(Carrier_i,j,A,S,Num_Of_Satellite);  % 改！根据传感器编号估计其在H矩阵中的行的位置
                for i = 0:3
                    for ii = Bottom:Top
                        if i ~= 3
                            H_(ii,Left+i) = -1 * (Satellite_Position((i+1),(ii+1-Bottom)) - X_Of_Sender_Carrier((i+1),1)) / D((ii+1-Bottom),1);
                        else
                            H_(ii,Left+i) = C;
                        end
                    end
                end
            end
        end 
    end
    for j = 1:n
        if A_Estimation_Trans(j,Carrier_i)==1
            [Sender_Carrier,~,Object] = Extract_Corresponding_Carrier(j,Carrier_i,Num);
            [Left,~] = Find_The_Column_Position_Of_H(Object,X_Carrier_Number_All,Which_Has_Four_Dimension);  % 根据载体编号估计其在H矩阵中的列的位置
            [Bottom,~] = Find_The_Row_Position_Of_H___(Carrier_i,j,A,S,Num_Of_Satellite);  % 改！根据载体编号估计其在H矩阵中的行的位置
            [~,X_Of_Object] = Extract_X_From_X_New(Sender_Carrier,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);
            D = X_Of_Object;
            for i = 0:1:2
                H_(Bottom+i,Left+i) = X_Of_Object(i+1,1)/D(i+1,1);
            end
        end
    end
    H_New = H_;
end