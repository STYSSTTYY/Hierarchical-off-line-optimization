function [S,S_Array] = Result(S_,A,Flag,S_Array_)
% 通过Result函数用动作A将状态S_推进到S
    S_Temp = S_;
    S_Temp{1,5} = [];
    [a,aa] = size(A{1,1});
    [b,bb] = size(A{1,2});
    if ((a==1)&&(aa==1))&&((b==1)&&(bb==1))
        if (isnan(A{1,1})) && (isnan(A{1,2}))
            S = S_;
            S_Array = S_Array_;
            return;
        end
    end
    if Flag ~= 2
        [~,X_All,P_All] = Calculating_X_And_P(A,S_);
        X_All_Temp = S_{1,1};
        P_All_Temp = S_{1,2};
    %     S_Temp{1,1} = P_All;
    %     S_Temp{1,2} = X_All;
        S_Temp{1,1} = Update_Result_P(S_Temp{1,1},P_All);  % 更新结果中的P
        S_Temp{1,2} = Update_Result_X(S_Temp{1,2},X_All);  % 更新结果中的X
        if isempty(P_All)
            S_Temp{1,1} = X_All_Temp;
        end
        if isempty(X_All)
            S_Temp{1,2} = P_All_Temp;
        end
    elseif Flag == 2
        if ~A_Is_NaN(A)  % 判断A是不是全为NaN，是全为NaN返回1，否返回0
            X_Trans = A{1,2};
            E_Trans = A{1,3};
            [~,Num] = size(X_Trans);
            for i = 1:Num
                if E_Trans(i,1) == 1
                    S_Temp = Trans_Results(S_Temp,i,X_Trans);  % 将最后结果传输到指定载体上
                end
            end
        end
    end
    S = S_Temp;
    SS = S_Array_{end,1};
    SS{1,5} = S_{1,5};
    S_Array_(end,1) = {SS};
    S_Array = S_Array_;
end