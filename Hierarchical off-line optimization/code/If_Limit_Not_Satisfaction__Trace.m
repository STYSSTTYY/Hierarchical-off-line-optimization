function [Flag,Temp] = If_Limit_Not_Satisfaction__Trace(P_All,S_Final)
% 分别检查每个载体上的性能要求是否满足，没满足1，满足0
    Flag = 0;
    Num = length(P_All);
    P_Requirements = S_Final{1,6};
    Temp = cell(Num,1);  % Temp每一行i代表载体i，上面是一个数组，代表这些不符合要求
    for k = 1:Num
        for i = 1:Num
            P_Now = P_All{1,k}((i-1)*3+1:i*3,(i-1)*3+1:i*3);
            P_Tar = P_Requirements{1,k}((i-1)*3+1:i*3,(i-1)*3+1:i*3);
            if isnan(trace(P_Tar))
            elseif ~isnan(trace(P_Now))
                if (trace(P_Now) > trace(P_Tar))
                    Flag = 1;
                    Temp{k,1} = [Temp{k,1},i];
                end
            else
                Flag = 1;
                Temp{k,1} = [Temp{k,1},i];
            end
        end
        Temp{k,1} = unique(Temp{k,1});
    end
end