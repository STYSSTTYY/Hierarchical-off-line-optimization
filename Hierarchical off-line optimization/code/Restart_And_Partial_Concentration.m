function [A_Array,S_,A,Flag,Appendix_,Flag_Central,S_Array,Appendix_Array,Flag_Partial_Concentration,RC_All_] = Restart_And_Partial_Concentration(Carriers,S_Final,RC_All)
% 重新开始搜索并且局部集中一下

%     P_All = Extract_Performance_Of_State(SS{1,1});  % 从当前状态中提取出所有载体上的互协方差矩阵
%     P = Sort_Out_Best_from_all_P_Trace(P_All);  % 从所有载体上当前存在的互协方差矩阵中整合出一个最好的代表上限，暂时只整理状态估计的方差,互协方差先不管
%     [Temp,Estimations_Positions] = If_Some_Satisfy_Performance_And_Costs_(S_Final,P_All,P);

    % 重新开始搜索
    [State,A_Array,S_Array,Appendix_Array,~,Flag,~,If_Random] = Restart_(Carriers);
    G = Build_Observation_Trans_Matrix(State{1,4});
    X = Build_Estimation_Trans_Matrix(State{1,4});
    E = Build_Estimation_Matrix(State{1,4});

    P_Upper_Limit = Upper_Limit_(State);  % 检查性能能够达到的上限(不考虑代价的情况下),同时不考虑第一步就存在有载体的状态估计解不出来的情况，因为这是应该加以避免的
    if If_Limit_Not_Satisfaction_Trace(P_Upper_Limit,S_Final)  % 检查性能上限能否满足性能要求,暂时只比较状态估计的方差。
        Flag = 0;
        A{1,1} = NaN;  % 传感器观测的传输
        A{1,2} = NaN;  % 状态估计的传输
        A{1,3} = NaN;  % 解算
        l = length(State{1,5});
        State{1,5}{l+1,1} = A;
        S_ = State;  % 如果性能上限都不满足性能要求的话，那么采取一个空的动作，并压入该状态下已经采取的动作里面
        return;
    end
    [State,A,Flag2,Relation_Map_,Observation_Map_,Select_Carrier_,Flag_Central,Flag_Partial_Concentration,RC_All_] = Partial_Concentration_(G,X,E,State,A_Array,S_Final,If_Random,RC_All);  % 选取一个可行的局部集中的动作
    S_ = State;
    Flag = Flag2;
    Appendix_ = cell(1,3);
    Appendix_{1,1} = Relation_Map_;
    Appendix_{1,2} = Observation_Map_;
    Appendix_{1,3} = Select_Carrier_;
end