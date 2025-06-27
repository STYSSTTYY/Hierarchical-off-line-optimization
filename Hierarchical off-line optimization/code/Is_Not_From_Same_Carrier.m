function flag = Is_Not_From_Same_Carrier(u1,u2,Num)
% 判断两条观测是否上一时刻来自于同一个载体，因为来自于同一个时刻同一个载体的状态估计之间的互协方差是可知的。不是来自同一个载体为1，是为0
    flag = 1;
    Carrier_u1 = fix((u1-1)/Num);
    Carrier_u1 = Carrier_u1 + 1;
    Carrier_u2 = fix((u2-1)/Num);
    Carrier_u2 = Carrier_u2 + 1;
    if Carrier_u2 == Carrier_u1
        flag = 0;
    else
        flag = 1;
    end
end