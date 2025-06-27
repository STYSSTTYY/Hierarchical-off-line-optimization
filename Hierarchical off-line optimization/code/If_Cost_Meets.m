function flag = If_Cost_Meets(Cal,Com,S_Final)
% 判断代价是否可接受，是输出1否输出0
    Num = length(S_Final{1,3}{1,2});
    for i = 1:Num
        if (Com(1,i)<S_Final{1,3}{1,2}(1,i)) || (Com(1,i)==S_Final{1,3}{1,2}(1,i))
            flag = 1;
        else
            flag = 0;
            return;
        end
    end
    Num = length(S_Final{1,3}{1,1});
    for i = 1:Num
        if (Cal(1,i)<S_Final{1,3}{1,1}(1,i)) || (Cal(1,i)==S_Final{1,3}{1,1}(1,i))
            flag = 1;
        else
            flag = 0;
            return;
        end
    end
end