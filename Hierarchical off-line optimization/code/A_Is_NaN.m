function Flag = A_Is_NaN(A)
% 判断A是不是全为NaN，是全为NaN返回1，否返回0
    Flag = 0;
    G = A{1,1};
    X = A{1,2};
    [a1,b1] = size(G);
    [a2,b2] = size(X);
    if ((a1==1)&&(b1==1)) && ((a2==1)&&(b2==1))
        if (isnan(G)) && (isnan(X))
            Flag = 1;
        end
    end
end