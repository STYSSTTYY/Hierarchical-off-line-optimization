function [flag,X_All,P_All] = Calculating_X_And_P_Comcentration(A,S)
% 根据采取的动作和当前的状态进行解算 默认加权最小二乘估计迭代10轮,并且输出判断是否有解，有解flag=1,无解flag=0
    flag = 1;
    Num_Of_Iteration = 10;
    Estimations = S{1,2};
    Sensor_Info = S{1,4};
    Num = length(S{1,4});
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    X_All = cell(1,Num);
    P_All = cell(1,Num);
    [a,b] = size(S{1,1}{1,1});
    [aa,bb] = size(S{1,2}{1,1});
    for i = 1:Num
        P_All{1,i} = ones(a,b)*NaN;
        X_All{1,i} = ones(aa,bb)*NaN;
    end
    if all(E(:) == 0)
        flag = 0;
        X_All = [];
        P_All = [];
        return;
    end
    for i = 1:Num
        if E(i,1)==1
            X = [];
            if ~isempty(X)
                X_Carrier_Number = X(:,1);
            else
                X_Carrier_Number = [];
            end
            [X_Carrier_Number_All,Z_Dimension,X_Dimension,Which_Has_Four_Dimension] = ...
                Carriers_Will_Be_Estimated_i(i,A,X_Carrier_Number,Sensor_Info);  % 改！根据动作得出载体i上将要解算的观测Z的总维度，状态估计X的总维度
            Delta_X = zeros(X_Dimension,1);
            H_ = zeros(Z_Dimension,X_Dimension);
            C_ = zeros(Z_Dimension,Z_Dimension);
            [C,Z] = Get_C_Z_i(i,A,S);  % 改！ 根据动作和状态给出加权最小二乘估计的C，Z
            Initial_X = Get_Initial_X(X_Carrier_Number_All,Which_Has_Four_Dimension);  %改！ 为了减少收敛所需次数，将真实值取做初值
            X_New = Initial_X;
            flag3 = 0;
            for j = 1:Num_Of_Iteration
                Delta_Z = Z - Z_Iteration(i,A,S,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);  %改！ 获取每一次迭代时的Delta_Z
                H_New = Get_H_New(i,A,S,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,H_);  %改！ 获取每一次迭代时最新的H
                [Flag,Delta_X] = Solve_Delta_X_WLSE(Delta_Z,H_New,C);  % 通过加权最小二乘估计计算每一次迭代后最新的Delta_X
                if ~Flag
                    flag = 0;
                    X_All = [];
                    P_All = [];
                    return;
                end
                X_New = X_New + Delta_X;  % 更新X
                if flag3 == 0
                    flag3 = 1;
                    [Flag2_,~,~] = Check_A_S(i,A,S); % 改！
                    if Flag2_
                        flag = 0;
                        X_All = [];
                        P_All = [];
                        return;
                    end
                end
            end
            [Flag,S_] = Solve_Covariance_Matrix(H_New,C);  % 最后计算协方差
            if ~Flag
                flag = 0;
                X_All = [];
                P_All = [];
                return;
            end
            % 检查到底能不能求解以及到底哪些理论上解得出来而实际上解不出来的模块，全是补丁，有待进一步完善
            [Flag2,~,~] = Check_A_S(i,A,S);  %改！ 根据未知数个数与方程条数的对应，找出哪些载体应该解算出来而没有解算出来，以及能不能解算出来，不能解算出来为1，能为0
            if Flag2
                flag = 0;
                X_All = [];
                P_All = [];
                return;
            end
            X_All{1,i} = Update_X(X_Carrier_Number_All,Which_Has_Four_Dimension,X_New,Estimations{1,i});  % 按状态内储存的格式输出本次解算的状态估计结果
            P_All{1,i} = Update_P(X_Carrier_Number_All,Which_Has_Four_Dimension,S_,S{1,1}{1,i});  % 按状态内储存的格式输出本次解算的协方差结果
        end
    end
    % Flag2 = Check_P_All(P_All);  % 还没写，由于各种误差的原因，前面判断能否有解的手段仍然不完善，最后的方法是检查接出来的东西的P，
                                   % 方差大的离谱的，其实是应该解不出来的，存在离谱方差的返回1，不存在返回0
%     if Flag2
%         flag = 0;
%     end
end