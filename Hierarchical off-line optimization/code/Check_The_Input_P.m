function flag = Check_The_Input_P(P_Final,P__)
% 检查一下，每一个载体的P和总的要求的P有没有冲突，这里主要检查把载体最好的P集合起来能不能符合总的P的要求，符合为1不符合为0
    [Num,~] = size(P_Final);
    Num = round(Num/3);
    for i = 1:Num
        P_Now = P__((i-1)*3+1:i*3,(i-1)*3+1:i*3);
        P_Tar = P_Final((i-1)*3+1:i*3,(i-1)*3+1:i*3);
        if isnan(trace(P_Tar))
            flag = 1;
        elseif ~isnan(trace(P_Now))
            if (trace(P_Now) > trace(P_Tar))
                flag = 0;
                return;
            else
                flag = 1;
            end
        else
            flag = 0;
            return;
        end
    end
end