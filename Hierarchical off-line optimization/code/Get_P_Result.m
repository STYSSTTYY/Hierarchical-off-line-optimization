function P_Result_ = Get_P_Result(Receiver_P,Temp,S_,j)
% 按格式给出载体j向载体i传输的协方差
    [a,b] = size(Receiver_P);
    P_Result = zeros(a,b);
    P_Result_ = ones(a,b)*NaN;
    Ref = S_{1,1}{1,j};
    for k = 1:length(Temp)
        Select = Temp(1,k);
        up = (Select-1)*3+1;
        down = Select*3;
        for kk = up:1:down
            for kkk = 1:b
                P_Result(kk,kkk) = P_Result(kk,kkk) + 1;
            end
        end
    end
    for k = 1:length(Temp)
        Select = Temp(1,k);
        left = (Select-1)*3+1;
        right = Select*3;
        for kk = left:1:right
            for kkk = 1:a
                P_Result(kkk,kk) = P_Result(kkk,kk) + 1;
            end
        end
    end
    for k = 1:a
        for kk = 1:b
            if P_Result(k,kk) == 2
                P_Result_(k,kk) = Ref(k,kk);
            end
        end
    end
end