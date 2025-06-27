function S_Temp1_2_ = Update_Result_X(S_Temp1_2,X_All)
% 更新结果中的X
    if isempty(X_All)
        S_Temp1_2_ = [];
        return;
    end
    [~,Num] = size(S_Temp1_2);
    S_Temp1_2_ = cell(1,Num);
    for i = 1:Num
        Temp1 = S_Temp1_2{1,i};
        Temp2 = X_All{1,i};
        [a,b] = size(Temp1);
        Temp3 = ones(a,b) * NaN;
        for j1 = 1:a
            for j2 = 1:b
                if ~isnan(Temp2(j1,j2))
                    Temp3(j1,j2) = Temp2(j1,j2);
                end
                if (~isnan(Temp1(j1,j2))) && (isnan(Temp2(j1,j2)))
                    Temp3(j1,j2) = Temp1(j1,j2);
                end
            end
        end
        S_Temp1_2_{1,i} = Temp3;
    end
end