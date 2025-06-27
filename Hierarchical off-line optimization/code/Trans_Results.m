function S_Temp = Trans_Results(S_,i,X_Trans)
% 将最后结果传输到指定载体上
    S_Temp = S_;
    S_Temp{1,5} = [];
    [n,Num] = size(X_Trans);
    Receiver_X = S_{1,2}{1,i};
    Receiver_P = S_{1,1}{1,i};
    Temp = cell(1,Num);  % 载体j要向载体i传输哪些状态估计，以数组的形式储存在cell(1,j)中
    for j = 1:n
        if X_Trans(j,i) == 1
            [Sender_Carrier,~,Object] = Extract_Corresponding_Carrier(j,i,Num);
            if Sender_Carrier ~= i
                Temp{1,Sender_Carrier} = [Temp{1,Sender_Carrier},Object];
            end
        end
    end
    for j = 1:Num
        if j ~= i
            if ~isempty(Temp{1,j})
                X_Result = Get_X_Result(Receiver_X,Temp{1,j},S_,j);  % 按格式给出载体j向载体i传输的状态估计
                P_Result = Get_P_Result(Receiver_P,Temp{1,j},S_,j);  % 按格式给出载体j向载体i传输的协方差
                for k = 1:length(Temp{1,j})
                    Select = Temp{1,j}(1,k);
                    Receiver_X(:,Select) = X_Result(:,Select);
                end
                [a,b] = size(P_Result);
                for c1 = 1:a
                    for c2 = 1:b
                        if ~isnan(P_Result(c1,c2))
                            Receiver_P(c1,c2) = P_Result(c1,c2);
                        end
                    end
                end
            end
        end
        S_Temp{1,1}{1,i} = Receiver_P;
        S_Temp{1,2}{1,i} = Receiver_X;
    end
end