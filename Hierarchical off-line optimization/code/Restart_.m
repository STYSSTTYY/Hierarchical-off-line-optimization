function [S,A_Array,S_Array,Appendix_Array,Memory_Bank,Flag_Of_Search,Appendix,If_Random] = Restart_(Carriers)
% 因为局部集中所以重新开始
    % 初始化
    S = Initial_State(Carriers); 
    A_Array = {};  S_Array = {};  Appendix_Array = {};
    S_Array(end+1,1) = {S};
    Memory_Bank = {};
    Memory_Bank(end+1,1) = {S};
    Memory_Bank(end,2) = {length(A_Array)};
    
    % 搜索问题重新开始
    Flag_Of_Search = 1;
    Appendix = cell(1,3);  % 储存一些额外的（本来应该放在State里面，但是不好改了）
    If_Random = 0;
    if isempty(A_Array)
        Relation_Map = [];
        Observation_Map = [];
        Select_Carrier = [];
        Appendix{1,1} = Relation_Map;
        Appendix{1,2} = Observation_Map;
        Appendix{1,3} = Select_Carrier;
    end
end