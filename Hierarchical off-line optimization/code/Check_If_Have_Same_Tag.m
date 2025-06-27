function flag = Check_If_Have_Same_Tag(temp4,Num)
% 检查某个时刻t传输到载体i上的所有状态估计是否有相同的信息来源，是1否0
    flag = 0;
    [m,~] = size(temp4);
    for j = 1:m-1
        temp1 = temp4{j,2};
        u1 = temp4{j,1};
        for jj = j+1:m
            temp2 = temp4{jj,2};
            u2 = temp4{jj,1};
            if Is_Not_From_Same_Carrier(u1,u2,Num)  % 判断两条观测是否上一时刻来自于同一个载体，因为来自于同一个时刻同一个载体的状态估计之间的互协方差是可知的。不是来自同一个载体为1，是为0
                if If_Have_Same_Tag(temp1,temp2)  % 判断两条观测的tag是否有重复部分，是1否0
                    flag = 1;
                    return;
                else
                    flag = 0;
                end
            end
        end
    end

end