function Temp = Substandard_Carriers_Trace(S_Final,P)
% 找出总的性能中哪些载体不达标。Temp储存了总的来看是哪些状态估计的精度没有达到要求。Temp每上面是一个数组，代表这些不符合要求，不达标的是1，达标的是0
    P_Require = S_Final{1,1};
    [a,~] = size(P);
    Num = a/3;
    Temp = zeros(1,Num);
    for i = 1:Num
        P_Tar = P_Require((i-1)*3+1:i*3,(i-1)*3+1:i*3);
        P_Now = P((i-1)*3+1:i*3,(i-1)*3+1:i*3);
        if ~isnan(trace(P_Tar))
            if (trace(P_Tar)<trace(P_Now))||(isnan(trace(P_Now)))
                Temp(1,i) = 1;
            end
        end
    end
end