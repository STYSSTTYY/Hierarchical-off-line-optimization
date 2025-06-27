function [A_Array_New,S_Array_New] = Simplify_The_Result(A_Array,S_Array,S_Initial,S_Final)
%  将结果简化，去除不必要的部分
    Steps = length(A_Array);
    Num_Of_Carriers = length(S_Array{1,1}{1,1});
    A = A_Array{end,1};
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    Num = length(E);
    [b,~] = size(X);
    Required_Positions_Matrix = S_Final{1,2};
    if (any(isnan(G)) + any(isnan(X)) + any(isnan(E))) == 3
        Steps = Steps - 1;
        S_Array = S_Array(1:end-1,1);
        A_Array = A_Array(1:end-1,1);
    end
    A = A_Array{end,1};
    E = A{1,3};
    if all(E==0)
        Flag_ = 2;
    else
        Flag_ = 1;
    end

    A_Array_New = {};
    S_Array_New = {};

    % 一步一步倒推
    for i = Steps:-1:1

        Locations = S_Array{i+1,1}{1,2};
        Existing_Positions_Matrix = zeros(Num_Of_Carriers,Num_Of_Carriers);  % 当前一步实际存在的状态估计矩阵
        Required_Positions_Matrix_ = zeros(Num_Of_Carriers,Num_Of_Carriers);  % 上一步必须存在的状态估计矩阵
        for Carrier_Number = 1:Num_Of_Carriers
            for Carrier_Object_Number = 1:Num_Of_Carriers
                Location = Locations{1,Carrier_Number}(:,Carrier_Object_Number);
                if ~any(isnan(Location))
                    Existing_Positions_Matrix(Carrier_Object_Number,Carrier_Number) = 1;
                end
            end
        end

        % 弄清楚当前状态下每一个必须存在的状态估计的来源
        A = A_Array{i,1};
        G = A{1,1};  [m1,n1] = size(G);  G_ = zeros(m1,n1);
        G_Temp = cell(Num_Of_Carriers,1); 
        X = A{1,2};  [m2,n2] = size(X);  X_ = zeros(m2,n2);
        X_Temp = cell(Num_Of_Carriers,1);
        E = A{1,3};  [m3,n3] = size(E);  E_ = zeros(m3,n3);
        E_Temp = cell(Num_Of_Carriers,1); 
        for j = 1:Num_Of_Carriers
            G_Temp{j,1} = G_;
            X_Temp{j,1} = X_;
            E_Temp{j,1} = E_;
        end
        E = A{1,3};
        for Carrier_Number = 1:Num_Of_Carriers
            for Carrier_Object_Number = 1:Num_Of_Carriers
                if Required_Positions_Matrix(Carrier_Object_Number,Carrier_Number) == 1  % 如果是必须存在的状态估计
                    if E(Carrier_Number,1) == 1
                        If_Trans = 0;  % 这个状态估计不是传输来的
                        If_Trans_ = 0;
                        for kk = 1:Num_Of_Carriers
                            if X((kk-1)*Num_Of_Carriers+Carrier_Number,Carrier_Object_Number)==1
                                If_Trans_ = 1;  % 第三种可能，这个状态估计既有传输来的，又有解算来的，此时If_Trans = 0 且If_Trans_ = 0
                                break;
                            end
                        end
                    else
                        If_Trans = 1;  % 这个状态估计是传输来的
                        If_Trans_ = 0;
                    end
                    if If_Trans  % 如果这个状态估计是传输来的，那么找出是谁传给它的
                        Carrier_k = Find_Who_Transfer(Carrier_Object_Number,Carrier_Number,X);  % 找出谁传给他的，假设是载体k
                        if isempty(Carrier_k)  % 如果找不到是谁传输的，说明是上一状态之前的状态的状态估计
                            %Retain_Message = Find_What_Message_Retain_(A,Carrier_Object_Number,Carrier_Number,Carrier_Number);    % 找出组成这个状态估计所需的信息
                            %[G_Temp,X_Temp,E_Temp] = Retain_G_X(G_Temp,X_Temp,E_Temp,Carrier_Object_Number,Retain_Message);  % 组成这个状态估计所需的所有信息在上一时刻必须保留
                            Required_Positions_Matrix_(Carrier_Object_Number,Carrier_Number) = 1;  % 说明在上一状态，该状态估计必须存在在原来的载体上
                        else
                            Retain_Message = Find_What_Message_Retain_(A,Carrier_Object_Number,Carrier_Number,Carrier_k);    % 找出组成这个状态估计所需的信息
                            [G_Temp,X_Temp,E_Temp] = Retain_G_X(G_Temp,X_Temp,E_Temp,Carrier_Object_Number,Retain_Message);  % 组成这个状态估计所需的所有信息在上一时刻必须保留
                            Required_Positions_Matrix_(Carrier_Object_Number,Carrier_k) = 1;  % 传输过来的状态估计说明在上一状态，该状态估计必须存在在传输过来的载体上
                        end
                    else  % 如果这个状态估计是解算出来的，那么组成这个状态估计所需的所有信息在上一时刻必须保留
                        Retain_Message = Find_What_Message_Retain(Carrier_Number,A);    % 找出组成这个状态估计所需的所有信息
                        [G_Temp,X_Temp,E_Temp] = Retain_G_X(G_Temp,X_Temp,E_Temp,Carrier_Object_Number,Retain_Message);  % 组成这个状态估计所需的所有信息在上一时刻必须保留
                        Required_Positions_Matrix_ = Get_Required_Positions_Matrix(Required_Positions_Matrix_,X_Temp);  % 从解算需要的信息中反推出上一状态需要在哪些载体上存在哪些状态估计
                    end
                end
            end
        end
        
        % 确定要留下的传输链路并生成新的简化后的动作
        G__ = zeros(m1,n1);
        X__ = zeros(m2,n2);
        E__ = zeros(m3,n3);
        for Carrier_Object_Number = 1:Num_Of_Carriers
            for c1 = 1:m1
                for d1 = 1:n1
                    if G_Temp{Carrier_Object_Number,1}(c1,d1) == 1
                        G__(c1,d1) = 1;
                    end
                end
            end
            for c2 = 1:m2
                for d2 = 1:n2
                    if X_Temp{Carrier_Object_Number,1}(c2,d2) == 1
                        X__(c2,d2) = 1;
                    end
                end
            end
            for c3 = 1:m3
                if E_Temp{Carrier_Object_Number,1}(c3,1) == 1
                    E__(c3,1) = 1;
                end
            end
        end
        A_New = cell(1,3);
        A_New{1,1} = G__;
        A_New{1,2} = X__;
        E__ = Generate_Carrier_Need_Calculating(G__,X__);
        A_New{1,3} = E__;

        % 建立简化后的动作序列和状态序列(这里是倒着的)
        A_Array_New(end+1,1) = {A_New};
        Required_Positions_Matrix = Required_Positions_Matrix_;
    end
    
    % 重新计算状态序列
    A_Array_New = flip(A_Array_New);
    S_Array_New(end+1,1) = {S_Initial};
    for i = 1:Steps
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
            %A_{1,2} = X_Temp;
            A_{1,2}(X_Temp==1) = 1;
            %A_{1,2}(X_Temp==0) = 0;
        end
        A_{1,3} = Generate_Carrier_Need_Calculating(A_{1,1},A_{1,2});
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
end