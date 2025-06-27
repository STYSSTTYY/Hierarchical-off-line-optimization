function [Temp,Estimations_Positions] = If_Some_Satisfy_Performance_And_Costs_(S_Final,P_All,P)
% Temp储存了总的来看是哪些状态估计的精度没有达到要求。Temp上面是一个数组，代表这些不符合要求，不达标的是1，达标的是0。Estimations_Positions找到性能最好的状态估计都在哪些载体上
    Temp_ = Substandard_Carriers_Trace(S_Final,P); % 找出总的性能中哪些载体不达标。Temp储存了总的来看是哪些状态估计的精度没有达到要求。Temp上面是一个数组，代表这些不符合要求，不达标的是1，达标的是0
    Temp = Temp_;
    Estimations_Positions = The_Location_Of_Estimations_Trace(P,P_All);  % 找到性能最好的状态估计都在哪些载体上
end