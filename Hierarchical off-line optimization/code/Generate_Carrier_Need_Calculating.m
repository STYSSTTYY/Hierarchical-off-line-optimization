function E = Generate_Carrier_Need_Calculating(G,X)
% 根据矩阵G和X决定解算E矩阵
    [a,aa] = size(G);
    [b,bb] = size(X);
    if ((a==1)&&(aa==1))&&((b==1)&&(bb==1))
        if (isnan(G)) && (isnan(X))
            E = NaN;
            return;
        end
    end
    [m,Num] = size(G);
    [n,~] = size(X);
    E = zeros(Num,1);
    for i = 1:Num
        for j = 1:m
            if G(j,i) == 1
                E(i,1) = 1;
            end
        end
        for j = 1:n
            if X(j,i) == 1
                E(i,1) = 1;
            end
        end
    end
end