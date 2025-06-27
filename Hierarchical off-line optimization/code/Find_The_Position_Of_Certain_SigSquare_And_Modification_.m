function C__ = Find_The_Position_Of_Certain_SigSquare_And_Modification_(i,k,Carrier_i,C,A,S,X,P,X_Carrier_i,Num_Of_Satellite)
%找出所有在载体Carrier_i上的i对k的相对观测的sigsquare在C矩阵中的位置并且进行相应修改
    G = A{1,1};
    C_= C;
    e = [];
    [m,~] = size(G);
    Sensor_Info = S{1,4};
    for j = 1:m
        if G(j,Carrier_i) == 1
            [Sender,~,~,If_Relative,Dimension,~,Object] ...
                = Extract_Corresponding_Sensor_Info(j,Carrier_i,Sensor_Info);
            if (If_Relative) + (Object==k) + (Sender==i) == 3
                [Row1,Row2] = Find_The_Row_Position_Of_H__(Carrier_i,j,A,S,Num_Of_Satellite);
                if Dimension == 1
                    e = ((X - X_Carrier_i)/norm(X - X_Carrier_i))';
                    %C_(Row1,Row1) = C_(Row1,Row1) + e*P*e';
                    C_(Row1,Row1) = C_(Row1,Row1);
                elseif Dimension ==3
                    %C_(Row1:Row2,Row1:Row2) = C_(Row1:Row2,Row1:Row2) + P;
                    C_(Row1:Row2,Row1:Row2) = C_(Row1:Row2,Row1:Row2);
                end
            end
        end
    end
    C__ = C_; 
end