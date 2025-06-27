clc,clear;
warning off;
Source_Of_Data = 1;  % 初始数据的来源，0代表现场输入，1代表来自于已有文件，2代表来自于Excel
global Num_Of_Satellite;
Num_Of_Satellite = 13;
global Base;
Base = 8;
global Carriers_Position;
global Satellite_Position;
if Source_Of_Data == 2
    FilePath_In = 'C:\Users\86158\Desktop\优化_搜索\Excel输入\Excel输入1';
    [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Excel(FilePath_In);  % 从Excel输入
    FilePath = 'C:\Users\86158\Desktop\优化_搜索\Some_Examples';
    Save_Inputs(Carriers,Carriers_Position,S_Final,Satellite_Position,FilePath);  % 将Excel的输入存入指定文件夹
elseif Source_Of_Data == 1
    FilePath = 'C:\Users\86158\Desktop\整理好的文件\博一上\Explicit_Hierarchical_Selection_for_Multi_Agent_Cooperative_Navigation_Fusion_Topologies\优化_搜索\Some_Examples\Example15';
    %FilePath = 'Some_Examples\Example5';
    [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Example(FilePath);
elseif Source_Of_Data == 0
    [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Keyboard();
    FilePath = 'C:\Users\86158\Desktop\优化_搜索\Some_Examples';
    Save_Inputs(Carriers,Carriers_Position,S_Final,Satellite_Position,FilePath);  % 将键盘的输入存入指定文件夹
end

% 初始化
tic
S = Initial_State(Carriers); 
[outputMatrix_Cell,outputMatrix,outputMatrix_G] = Build_Observation_Map(S);
A_Array = {};  S_Array = {};  Appendix_Array = {};
S_Array(end+1,1) = {S};
Memory_Bank = {};
Memory_Bank(end+1,1) = {S};
Memory_Bank(end,2) = {length(A_Array)};

% 搜索问题开始
Flag_Of_Search = 1;
js = 0;
Appendix = cell(1,3);  % 储存一些额外的（本来应该放在State里面，但是不好改了）

while Flag_Of_Search == 1
%while false
    If_Random = 0;
    %[S_,A,Flag_Of_Search] = Action(S,A_Array,S_Final);  % 还没检验好，第一步有待改进，选取一个动作
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
        [A_Array,S_,A,Flag_Of_Search,Appendix,Flag_Central,S_Array,Appendix_Array,Flag_Partial_Concentration,RC_All] = Restart_And_Partial_Concentration(Carriers,S_Final,RC_All);  % 重新开始搜索并且局部集中一下
    end
    Flag_Of_Search = If_Repeat_Action(A,S_,Flag_Of_Search);  % 检查该动作是否之前出现过
    if Flag_Of_Search == 0
        [Flag_Back,S,S_Array,A_Array,Appendix,Appendix_Array,Memory_Bank,If_Random] = Take_A_Step_Backward(S_Array,A_Array,Appendix_Array,1,Carriers,Memory_Bank);  % 取不出动作了，回退一个状态 Flag_Back=1代表回退成功，Flag_Back=0代表无法回退
        if ~Flag_Back
            Flag_Of_Search = 0;  % Flag_Of_Search=0代表搜索失败了
            break;
        else
            Flag_Of_Search = 1;
        end
    else
        [S,S_Array] = Result(S_,A,Flag_Of_Search,S_Array);  % 通过Result函数用动作A将状态S_推进到S
        [S_Array,A] = Amendment_A_S(S_Array,A,Flag_Of_Search);  % 将Flag_Of_Search=2时的一种情况修正
        A_Array(end+1,1) = {A};
        S_Array(end+1,1) = {S};
        Appendix_Array(end+1,1) = {Appendix};
        Memory_Bank(end+1,1) = {S};
        Memory_Bank(end,2) = {length(A_Array)};
    end

end

Flag_Central=0;
if Flag_Central==1  % 明确了，要集中式
    disp('集中式')
    [A,S,A_Array,S_Array,Flag_Of_Search] = Centralize_Carriers(Carriers,S_Final);  % 采用集中式的方法
end
% 结果解释和输出
if Flag_Of_Search  % 如果搜索成功的话
    Print_Successful_Result(A_Array,S_Array,S_Final,Carriers);  % 输出成功时的结果
    %[A_Array,S_Array] = Simplify_The_Result(A_Array,S_Array,Initial_State(Carriers),S_Final);  % 将结果简化，去除不必要的部分
    Print_Successful_Result(A_Array,S_Array,S_Final,Carriers);  % 输出成功时的结果
    toc
    Draw_Successful_Result(A_Array,S_Array,S_Final,outputMatrix,outputMatrix_G,outputMatrix_Cell);  % 画出成功时的结果
    % Save_The_Results(A_Array,S_Array,FilePath);  % 将成功时的结果存入指定文件夹

else  % 如果搜索失败的话
    %Print_Failed_Result();  % 输出失败时的结果
    kkkdkd = 9
end