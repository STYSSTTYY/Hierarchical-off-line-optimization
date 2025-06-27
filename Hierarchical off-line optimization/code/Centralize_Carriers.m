function [A,S,A_Array,S_Array,Flag_Of_Search] = Centralize_Carriers(Carriers,S_Final)
% 采用集中式的方法
    % 初始化
    S = Initial_State(Carriers); 
    A_Array = {};  S_Array = {};
    S_Array(end+1,1) = {S};
    Memory_Bank = {};
    Memory_Bank(end+1,1) = {S};
    Memory_Bank(end,2) = {length(A_Array)};
    Flag_Of_Search = 1;  % Flag_Of_Search=1代表搜索成功

    Sensor_Info = S{1,4};
    G = Build_Observation_Trans_Matrix(Sensor_Info);
    X = Build_Estimation_Trans_Matrix(Sensor_Info);
    E = Build_Estimation_Matrix(Sensor_Info);
    A = cell(1,3);
    A{1,1} = G;
    [n,~] = size(G);
    A{1,2} = X;
    A{1,3} = E;
    A_Array(end+1,1) = {A};
    Num = length(E);

    I = [];
    P_Upper_Limit = Upper_Limit_Central(S,A_Array);
    for i = 1:Num
        for j = 1:Num
            P_Required = S_Final{1,1}((j-1)*3+1:j*3,(j-1)*3+1:j*3);
            P_Now = P_Upper_Limit{i,3}{1,i}((j-1)*3+1:j*3,(j-1)*3+1:j*3);
            if isnan(trace(P_Required))
                Flag_I = 1;
            else
                if isnan(trace(P_Now))
                    Flag_I = 0;
                    break;
                else
                    if trace(P_Now)<=trace(P_Required)
                        Flag_I = 1;
                    else
                        Flag_I = 0;
                        break
                    end
                end
            end
        end
        if Flag_I==1
            I = [I,i];
            Flag_I = 0;
        end
    end
   
    II = [];
    Com_All = [];
    if isempty(I)
        Flag_Of_Search = 0;
    else
        for i = 1:length(I)
            G = Build_Observation_Trans_Matrix(Sensor_Info);
            for k = 1:n
                G(k,I(i)) = 1;  % 假设将所有的信息都集中到第一个载体上来，所以第一列的传感器传输都是1
            end
            A{1,1} = G;
            A{1,2} = X;
            A{1,3} = Generate_Carrier_Need_Calculating(G,X);
            Cal = Cal_Cost(A,S); % 计算该动作的运算代价
            Com = Com_Cost(A,S); % 计算该动作的通信代价
            if (Cal(I(i)) <= S_Final{1,3}{1,1}(I(i)))&&(Com(I(i)) <= S_Final{1,3}{1,2}(I(i)))
                II = [II,I(i)];
                Com_All = [Com_All,(S_Final{1,3}{1,2}(I(i))-S{1,3}{1,2}(I(i)))];
            end
        end
    end

    if isempty(II)
        Flag_Of_Search = 0;
    else
        [~,Index] = max(II);
        i = II(Index);
    end

    G = Build_Observation_Trans_Matrix(Sensor_Info);
    for j = 1:n
        G(j,i) = 1;
    end
    X = Build_Estimation_Trans_Matrix(Sensor_Info);
    E = Generate_Carrier_Need_Calculating(G,X);
    A{1,1} = G;
    A{1,2} = X;
    A{1,3} = E;

    [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S(i,A,S);
    if Flag2==1
        [A,~,~]= Eliminate_Carrier_Cant_Solved(Carriers_Number,X_Carrier_Number_All,FC_Now,A,S);
    end
    [~,X_All,P_All] = Calculating_X_And_P(A,S);
    Cal = Cal_Cost(A,S); % 计算该动作的运算代价
    Com = Com_Cost(A,S); % 计算该动作的通信代价
    % 如果这个动作可以采用
    l = length(S{1,5});
    S{1,5}{l+1,1} = A;  % 将已经判断可以采用的动作也压入已经采取过的动作里面以免下次又被采用
    S{1,3}{1,1} = Cal;
    S{1,3}{1,2} = Com;
    S{1,1} = Update_Result_P(S{1,1},P_All);  % 更新结果中的P
    S{1,2} = Update_Result_X(S{1,2},X_All);  % 更新结果中的X
    A_Array(end,1) = {A};
    S_Array(end+1,1) = {S};
    S{1,5} = [];

    if Flag_Of_Search==0
        return;
    else
        P_All = Extract_Performance_Of_State(S{1,1});  % 从当前状态中提取出所有载体上的互协方差矩阵
        G = Build_Observation_Trans_Matrix(Sensor_Info);
        E = Build_Estimation_Matrix(Sensor_Info);
        if If_Satisfy_All_Requirements(S,S_Final,P_All)  % 如果已经满足了全部的要求，已经满足了1否0
            A{1,1} = NaN;
            A{1,2} = NaN;
            A{1,3} = NaN;  % 如果是的的话，输出一个空的动作
            l = length(S{1,5});
            S{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
            Flag3 = 2;
        elseif If_Satisfy_Performance_And_Costs(S,S_Final,P_All)  % 如果已经满足了性能要求和代价要求，已经满足了1否0
            A{1,1} = G;
            [Flag,X_,E_] = Build_X_Final(S,S_Final,P_All,X,E);  % 建立一个最后的，仅仅用于传输结果到正确位置的矩阵，Flag返回是否存在这样的符合代价要求的矩阵，存在1，不存在0
            if Flag
                A{1,2} = X_;
                A{1,3} = E_;
                % 如果这个动作可以采用
                l = length(S{1,5});
                S{1,5}{l+1,1} = A;  % 将已经判断可以采用的动作也压入已经采取过的动作里面以免下次又被采用
                Cal = S{1,3}{1,1};
                Com = Com_Cost_(A,S);  % 计算该步传输的通讯代价
                S{1,3}{1,1} = Cal;
                S{1,3}{1,2} = Com;
                Flag3 = 2;
            else
                A{1,1} = NaN;
                A{1,2} = NaN;
                A{1,3} = NaN;
                l = length(S{1,5});
                S{1,5}{l+1,1} = A;  % 空的动作也压入已经采取过的动作里面
                Flag3 = 0;
            end
        end
    end

    if Flag3==0
        Flag_Of_Search = 0;
        return;
    else
        X_Trans = A{1,2};
        E_Trans = A{1,3};
        [~,Num] = size(X_Trans);
        for i = 1:Num
            if E_Trans(i,1) == 1
                S = Trans_Results(S,i,X_Trans);  % 将最后结果传输到指定载体上
            end
        end
        [S_Array,A] = Amendment_A_S(S_Array,A,Flag3);
        Flag_Of_Search = 1;
        A_Array(end+1,1) = {A};
        S_Array(end+1,1) = {S};
    end
end