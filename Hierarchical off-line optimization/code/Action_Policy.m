function [S,A,Flag,Appendix_,Flag_Central,Flag_Partial_Concentration,RC_All] = Action_Policy(State,A_Array,S_Final,Appendix,If_Random)
% 根据当前的状态得出动作，Flag是一个标志，Flag=0代表无可用动作且动作输出为NAN，Flag=1代表正常动作，Flag=2代表最后一个动作
    Relation_Map = Appendix{1,1};
    Observation_Map = Appendix{1,2};
    Select_Carrier = Appendix{1,3};
    G = Build_Observation_Trans_Matrix(State{1,4});
    X = Build_Estimation_Trans_Matrix(State{1,4});
    E = Build_Estimation_Matrix(State{1,4});
    if ~isempty(A_Array)  % 如果不是第一步动作
        P_Upper_Limit = Upper_Limit(State,A_Array); % 检查性能能够达到的上限
       if If_Limit_Not_Satisfaction_Trace(P_Upper_Limit,S_Final) % 检查性能上限能否满足性能要求
            Flag = 0;
            A{1,1} = NaN;  % 传感器观测的传输
            A{1,2} = NaN;  % 状态估计的传输
            A{1,3} = NaN;  % 解算
            l = length(State{1,5});
            State{1,5}{l+1,1} = A;
            S = State;  % 如果性能上限都不满足性能要求的话，那么采取一个空的动作，并压入该状态下已经采取的动作里面
            Appendix_ = {};
            Flag_Central = 0;
            Flag_Partial_Concentration = 0;
            RC_All = [];
            return;
        end
        % Relation_Map Num*Num矩阵，只记录不同载体需要哪些程度的融合信息，不记录具体在哪里融合
        % Observation_Map Num*Num矩阵，只记录不同载体之间有哪些观测（绝对、相对）
        % Select_Carrier 1*Num矩阵，记录载体的结果需要在哪里解算
        %[State,A,Flag2,Relation_Map,Observation_Map,Select_Carrier] = Policy(G,X,E,State,A_Array,S_Final,0,[],[],[]);  % 还没写，选取一个可行的动作
        [State,A,Flag2,Relation_Map_,Observation_Map_,Select_Carrier_,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy(G,X,E,State,A_Array,S_Final,0,Relation_Map,Observation_Map,Select_Carrier,If_Random);
        S = State;
        Flag = Flag2;

    else  % 如果就是第一步动作
        P_Upper_Limit = Upper_Limit_(State);  % 检查性能能够达到的上限(不考虑代价的情况下),同时不考虑第一步就存在有载体的状态估计解不出来的情况，因为这是应该加以避免的
        if If_Limit_Not_Satisfaction_Trace(P_Upper_Limit,S_Final)  % 检查性能上限能否满足性能要求,暂时只比较状态估计的方差。
            Flag = 0;
            A{1,1} = NaN;  % 传感器观测的传输
            A{1,2} = NaN;  % 状态估计的传输
            A{1,3} = NaN;  % 解算
            l = length(State{1,5});
            State{1,5}{l+1,1} = A;
            S = State;  % 如果性能上限都不满足性能要求的话，那么采取一个空的动作，并压入该状态下已经采取的动作里面
            return;
        end
        [State,A,Flag2,Relation_Map_,Observation_Map_,Select_Carrier_,Flag_Central,Flag_Partial_Concentration,RC_All] = Policy(G,X,E,State,A_Array,S_Final,1,[],[],[],If_Random);  % 选取一个可行的动作
        S = State;
        Flag = Flag2;
    end
    Appendix_ = cell(1,3);
    Appendix_{1,1} = Relation_Map_;
    Appendix_{1,2} = Observation_Map_;
    Appendix_{1,3} = Select_Carrier_;
end