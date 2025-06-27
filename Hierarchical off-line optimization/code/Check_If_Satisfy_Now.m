function Flag_If_Satisfy_Now = Check_If_Satisfy_Now(A_Array,X,State,FC_Now,Estimation,S_Final)
% 判断现在是否满足要求，满足要求Flag_If_Satisfy_Now=1，不满足要求Flag_If_Satisfy_Now=0
    S_Array_New = {};
    A_Array_New = A_Array;
    S_Temp = State;
    [aa,bb] = size(State{1,1}{1,1});
    [cc,dd] = size(State{1,2}{1,1});
    [b,Num] = size(X);
    for i = 1:Num
        S_Temp{1,1}{1,i} = NaN*ones(aa,bb);
        S_Temp{1,2}{1,i} = NaN*ones(cc,dd);
    end
    
    % 重新计算状态序列
    Steps = length(A_Array);
    S_Array_New(end+1,1) = {S_Temp};
    for i = 1:Steps
        Flag_ = 1;
        if (i == Steps) && (Flag_ == 2)
            Flag = 2;
        else
            Flag = 1;
        end
        State = S_Array_New{end,1};
        A_ = A_Array_New{i,1};
        if (i == Steps) && (Flag_ == 2)
        else
            Est = 1:1:Num;
            X_Temp = Get_Estimations_Last_Step_Est(Est,Num,A_{1,2},State);  % 把前一步的状态估计带上
            for k = 1:Num
                if all(A_{1,1}(:,k)==0)
                    X_Temp(:,k) = zeros(b,1);
                end
            end
            A_{1,2}(X_Temp==1) = 1;
        end
        A_{1,3} = Generate_Carrier_Need_Calculating(A_{1,1},A_{1,2});
        for iii = 1:Num
            if A_{1,3}(iii)==1
                [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S(iii,A_,State);
                if Flag2==1
                    [A_,~,~]= Eliminate_Carrier_Cant_Solved(Carriers_Number,X_Carrier_Number_All,iii,A_,State);
                end
            end
        end
        if (i == Steps) && (Flag_ == 2)
            Cal = State{1,3}{1,1};
            Com = Com_Cost_(A_,State);  % 计算该步传输的通讯代价
            State{1,3}{1,1} = Cal;
            State{1,3}{1,2} = Com;
        else
            Cal = Cal_Cost(A_,State); % 计算该动作的运算代价
            Com = Com_Cost(A_,State); % 计算该动作的通信代价
            State{1,3}{1,1} = Cal;
            State{1,3}{1,2} = Com;
        end
        % 采用这个动作
        l = length(State{1,5});
        State{1,5}{l+1,1} = A_;  % 将已经判断可以采用的动作也压入已经采取过的动作里面以免下次又被采用
        State_ = State;
        [S,S_Array_New] = Result(State_,A_,Flag,S_Array_New);  % 通过Result函数用动作A将状态S_推进到S
        [S_Array_New,A_] = Amendment_A_S(S_Array_New,A_,Flag);  % 将Flag=2时的一种情况修正
        A_Array_New{i,1} = A_;
        S_Array_New(end+1,1) = {S};
    end
    P_Temp = S_Array_New{end}{1,1}{1,FC_Now}((Estimation-1)*3+1:Estimation*3,(Estimation-1)*3+1:Estimation*3);
    P_Tar = S_Final{1,1}((Estimation-1)*3+1:Estimation*3,(Estimation-1)*3+1:Estimation*3);
    if ~isnan(trace(P_Tar))
        if ~isnan(trace(P_Temp))
            if trace(P_Temp)<=trace(P_Tar)
                Flag_If_Satisfy_Now = 1;  % 这一轮理论上可以实现精度
            else
                Flag_If_Satisfy_Now = 0;
            end
        else
            Flag_If_Satisfy_Now = 0;
        end
    else
        Flag_If_Satisfy_Now = 1;
    end
end