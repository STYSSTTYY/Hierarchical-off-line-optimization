function [Flag_Partial_Concentration, RC] = Take_Partial_Concentration_Action(Est)
% 生成一个局部集中式的动作,能1否0
    if ~isempty(Est)
        RC = Est;
        Flag_Partial_Concentration = 1;
    else
        RC = [];
        Flag_Partial_Concentration = 0;
    end
end