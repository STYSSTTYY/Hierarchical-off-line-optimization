function Required_Positions_Matrix_ = Get_Required_Positions_Matrix(Required_Positions_Matrix,X_Temp)
%  从解算需要的信息中反推出上一状态需要在哪些载体上存在哪些状态估计
    l = length(X_Temp);
    for k = 1:l
        X = X_Temp{k,1};
        [a,b] = size(X);
        for i = 1:a
            for j = 1:b
                if X(i,j) == 1
                    [Sender_Carrier,~,Object] = Extract_Corresponding_Carrier(i,j,b);
                    Required_Positions_Matrix(Object,Sender_Carrier) = 1;
                end
            end
        end
    end
    Required_Positions_Matrix_ = Required_Positions_Matrix;
end