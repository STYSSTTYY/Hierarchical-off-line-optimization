function [Flag3,X] = Generate_Estimation_Trans(Number_List,Number_List2,X_,S,S_Final)
% 根据每个载体缺哪些状态估计和每个载体存在哪些状态估计，生成一个传输的矩阵X，Flag3=1代表存在这样的矩阵，=0代表不存在
    global Base;
    X = X_;
    Costs_Limits = S_Final{1,3}{1,2};
    Costs_Now = S{1,3}{1,2};
    [~,Num] = size(Costs_Now);
    Costs_Most = Costs_Limits - Costs_Now;
    % Number_List每一行i代表载体i，上面是一个数组，代表这些状态估计应该存在在载体i上却没有出现
    % Number_List2每一行i代表载体i，上面是一个数组，代表这些状态估计都是真实存在在载体i上的
    f = zeros(Num*Num*Num,1);
    intcon = 1:Num*Num*Num; % 整数变量索引向量
    lb = zeros(Num*Num*Num,1);
    ub = zeros(Num*Num*Num,1);
    A = zeros(Num,Num*Num*Num);
    b = Costs_Most;
    Aeq = zeros(Num*Num,Num*Num*Num);
    Beq = zeros(Num*Num,1);
    for i = 1:Num
        for j = 1:Num
            for k = 1:Num
                q = (i-1)*Num*Num + (j-1)*Num + k;
                A(j,q) = Base*12;  % 3*3的协方差矩阵，3维的状态估计，发送的代价
                A(i,q) = Base*12;  % 接收的代价（后来加的）
                if (ismember(k,Number_List{i,1})) && (ismember(k,Number_List2{j,1}))
                    ub(q,1) = 1;
                end
                if ismember(k,Number_List{i,1}) % 判断客户i是否需要货物k
                    Aeq((i-1)*Num+k,q) = 1; % 赋值线性等式约束系数
                    Beq((i-1)*Num+k) = 1; % 赋值线性等式约束右端常数
                end
            end
        end
    end
    options = optimoptions('intlinprog','Display','off');
    [x,~,exitflag,~] = intlinprog(f,intcon,A,b,Aeq,Beq,lb,ub,options);
    if exitflag > 0
        x(intcon) = round(x(intcon));
        Flag3 = 1;
        for p = 1:Num*Num*Num
            if x(p,1) == 1
                i = fix((p-1)/(Num*Num)) + 1;
                p_ = p - (i-1)*Num*Num;
                j = fix((p_-1)/Num) + 1;
                k = p_ - (j-1)*Num;
                X(((j-1)*Num+k),i) = 1;
            end
        end
    else
        Flag3 = 0;
        X = X_;
    end
end