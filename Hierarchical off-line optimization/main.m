clc,clear;
warning off;
Source_Of_Data   = 1;
global Num_Of_Satellite;
Num_Of_Satellite = 13;
global Base;
Base             = 8;
global Carriers_Position;
global Satellite_Position;

thisFile   = mfilename('fullpath'); 
projRoot   = fileparts(thisFile);          
funcDir    = fullfile(projRoot, 'code');
if ~contains(path, funcDir)                 
    addpath(funcDir);
end
clear funcDir
dataDir    = fullfile(projRoot, 'Some_Examples');

if Source_Of_Data == 1
    Example_name = 'Example21';
    FilePath = fullfile(dataDir, Example_name);
    [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Example(FilePath);
end

tic
S = Initial_State(Carriers); 
[outputMatrix_Cell,outputMatrix,outputMatrix_G] = Build_Observation_Map(S);
A_Array = {};  S_Array = {};  Appendix_Array = {};
S_Array(end+1,1) = {S};
Memory_Bank = {};
Memory_Bank(end+1,1) = {S};
Memory_Bank(end,2) = {length(A_Array)};

Flag_Of_Search = 1;
js = 0;
Appendix = cell(1,3);

while Flag_Of_Search == 1
    If_Random = 0;
    if isempty(A_Array)
        Relation_Map = [];
        Observation_Map = [];
        Select_Carrier = [];
        Appendix{1,1} = Relation_Map;
        Appendix{1,2} = Observation_Map;
        Appendix{1,3} = Select_Carrier;
    end
    [S_,A,Flag_Of_Search,Appendix,Flag_Central,Flag_Partial_Concentration,RC_All] = Action_Policy(S,A_Array,S_Final,Appendix,If_Random);  % 还没检验好，第一步有待改进，选取一个动作
    if Flag_Central==1
        break;
    end
    if (Flag_Partial_Concentration == 1) && (~isempty(RC_All))
        [A_Array,S_,A,Flag_Of_Search,Appendix,Flag_Central,S_Array,Appendix_Array,Flag_Partial_Concentration,RC_All] = Restart_And_Partial_Concentration(Carriers,S_Final,RC_All);  
    end
    Flag_Of_Search = If_Repeat_Action(A,S_,Flag_Of_Search);  
    if Flag_Of_Search == 0
        [Flag_Back,S,S_Array,A_Array,Appendix,Appendix_Array,Memory_Bank,If_Random] = Take_A_Step_Backward(S_Array,A_Array,Appendix_Array,1,Carriers,Memory_Bank); 
        if ~Flag_Back
            Flag_Of_Search = 0;  
            break;
        else
            Flag_Of_Search = 1;
        end
    else
        [S,S_Array] = Result(S_,A,Flag_Of_Search,S_Array);  
        [S_Array,A] = Amendment_A_S(S_Array,A,Flag_Of_Search);  
        A_Array(end+1,1) = {A};
        S_Array(end+1,1) = {S};
        Appendix_Array(end+1,1) = {Appendix};
        Memory_Bank(end+1,1) = {S};
        Memory_Bank(end,2) = {length(A_Array)};
    end
end

Flag_Central=0;
if Flag_Central==1 
    disp('集中式')
    [A,S,A_Array,S_Array,Flag_Of_Search] = Centralize_Carriers(Carriers,S_Final);
end

if Flag_Of_Search
    %[A_Array,S_Array] =
    %Simplify_The_Result(A_Array,S_Array,Initial_State(Carriers),S_Final);
    %%这个函数已经写好了，用来简化优化结果，但是有些时候不一定对，需要进一步调整
    Print_Successful_Result(A_Array,S_Array,S_Final,Carriers);
    Draw_Successful_Result(A_Array,S_Array,S_Final,outputMatrix,outputMatrix_G,outputMatrix_Cell);
    %Save_The_Results(A_Array,S_Array,FilePath); 
else  
    Print_Failed_Result();
end
toc
