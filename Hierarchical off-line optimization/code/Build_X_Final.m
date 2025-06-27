function [Flag,X,E_] = Build_X_Final(State,S_Final,P_All,X,E)
% 建立一个最后的，仅仅用于传输结果到正确位置的矩阵，Flag返回是否存在这样的符合代价要求的矩阵，存在1，不存在0
% 不考虑转发！！！
    Flag = 0;
    Estimations_Required = S_Final{1,2};
    % Estimations_Positions = The_Location_Of_Estimations(P,P_All);  % 找到性能最好的状态估计都在哪些载体上
    [Flag2,Temp] = If_Limit_Not_Satisfaction__Trace(P_All,S_Final);  % Temp储存了每一个载体上是哪些状态估计的精度没有达到要求
    if ~Flag2  % 如果是性能条件完全符合，仅仅是有些状态估计没有出现在应有的位置上，这时候最后一步的载体传输可以不考虑方差与协方差，因为反正都满足要求了
        Number_List = Find_Absent_Estimations(State,Estimations_Required);  % 找到每个载体缺了哪些状态估计
        Number_List2 = Find_Exsist_Estimations(State);  % 找到每个载体存在哪些状态估计
        [Flag3,X] = Generate_Estimation_Trans(Number_List,Number_List2,X,State,S_Final);  % 根据每个载体缺哪些状态估计和每个载体存在哪些状态估计，生成一个传输的矩阵X，Flag3=1代表存在这样的矩阵，=0代表不存在
        if Flag3
            Flag = 1;
            return;
        else
            Flag = 0;
            return;
        end
    end
    % 其它情况就是总的性能满足要求，但是具体的载体上可能有些问题，这时候最后一步的状态估计的传输是需要考虑传输的状态估计的方差与协方差的
    Number_List = Find_Absent_Estimations(State,Estimations_Required);  % 找到每个载体缺了哪些状态估计
    Number_List2 = Find_Exsist_Estimations(State);  % 找到每个载体存在哪些状态估计

    % Temp每一行i代表载体i，上面是一个数组，代表这些状态估计精度不符合要求
    % Estimations_Positions每一行代表载体i的状态估计，内存有一数组，代表这精度高的状态估计i存在于哪些载体上
    % Number_List每一行i代表载体i，上面是一个数组，代表这些状态估计应该存在在载体i上却没有出现
    % Number_List2每一行i代表载体i，上面是一个数组，代表这些状态估计都是真实存在在载体i上的
    [Flag4,X] = Generate_Estimation_Trans2_Trace(Temp,Number_List,Number_List2,State,S_Final,X);  % 根据每一个载体上是哪些状态估计的精度没有达到要求的Temp
                                                                                            % 找到每个载体缺了哪些状态估计的Number_List，每个载体存在哪些状态估计的Number_List2以及当前的状态和最终的状态要求S_Final，求出一个可行的状态估计传输矩阵
                                                                                            % Flag4=1代表这样的矩阵存在，=0代表不存在
    E_ = E;
    if Flag4
        Flag = 1;
        [Num,~] = size(E);
        [n,~] = size(X);
        for i = 1:Num
            Flag_1 = 0;
            for j = 1:n
                if X(j,i) == 1
                    Flag_1 = 1;
                    break;
                end
            end
            if Flag_1
                E_(i,1) = 1;
            end
        end
        return;
    else
        % 这里也有可能仅仅是通讯能力不足，可以通过就地更高精度的解算解决，可能会与Generate_Carrier_Need_Calculating(G,X)相似，最后再回头想想
        
        Flag = 0;
        return;
    end
end