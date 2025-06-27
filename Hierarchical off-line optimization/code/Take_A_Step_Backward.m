function [Flag_Back,S,S_Array_Temp,A_Array_Temp,Appendix,Appendix_Array_Temp,Memory_Bank_,If_Random] = Take_A_Step_Backward(S_Array,A_Array,Appendix_Array,steps,Carriers,Memory_Bank)
% 取不出动作了，回退一个状态 Flag_Back=1代表回退成功，Flag_Back=0代表无法回退
%   steps：回退几步
    Flag_Back = 1;
    N = length(S_Array);
    If_Random = 0;
    if N <= steps
        %  直接回退到第零步
        Flag_Back = 0;
        If_Random = 1;
        S = Initial_State(Carriers); 
        A_Array_Temp = {};  S_Array_Temp = {};  Appendix_Array_Temp = {};
        S_Array_Temp(end+1,1) = {S};
        Relation_Map = [];
        Observation_Map = [];
        Select_Carrier = [];
        Appendix{1,1} = Relation_Map;
        Appendix{1,2} = Observation_Map;
        Appendix{1,3} = Select_Carrier;
        Memory_Bank(end+1,1) = {S};
        Memory_Bank(end,2) = {length(A_Array)};
        Memory_Bank_ = Memory_Bank;
        return;
    else
        S_Array_Temp = S_Array(1:end-steps,1);
        A_Array_Temp = A_Array(1:end-steps,1);
        Appendix_Array_Temp = Appendix_Array(1:end-steps,1);
        S = S_Array{end-steps,1};
        if length(Appendix_Array)==1
            Appendix = {};
        else
            Appendix = Appendix_Array{end-steps,1};
        end
        Memory_Bank(end+1,1) = {S};
        Memory_Bank(end,2) = {length(A_Array_Temp)};
        Memory_Bank_ = Memory_Bank;
        If_Random = 1;
    end
end