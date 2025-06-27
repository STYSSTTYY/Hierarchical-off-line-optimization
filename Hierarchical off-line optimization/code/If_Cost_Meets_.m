function Flag = If_Cost_Meets_(State,S_Final)
% 判断当前状态是否满足Cost要求，满足要求Flag=1，不满足要求Cost=0
    Cal = State{1,3}{1,1};
    Com = State{1,3}{1,2};
    Flag = If_Cost_Meets(Cal,Com,S_Final);
end