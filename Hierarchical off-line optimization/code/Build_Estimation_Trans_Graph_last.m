function Estimation_Trans_Graph = Build_Estimation_Trans_Graph_last(A_New,A_Array,S,Num_Of_Satellite)
% 根据状态估计各个时序上的传输结合最新的动作，建立一张最新的状态估计传输矩阵。
    Time = length(A_Array);
    Sensor_Info = S{1,4};
    X_New = A_New{1,2};
    [~,Num] = size(X_New);
    X_All = zeros((Time+1)*Num,(Time+1)*Num);
    A1 = A_Array{1,1};
    X_Carrier_Number = [];
    X1 = cell(Num,1);
    X2 = cell(Num,1);
    for i = 1:Num
        [X_,~,~,~] = Carriers_Will_Be_Estimated_i_(i,A1,X_Carrier_Number,Sensor_Info,Num_Of_Satellite);  % 改！
        X1{i,1} = X_;
    end
    
    A_Array{Time+1,1} = A_New;
    Time = Time + 1;

    for t = 2:Time

        Temp2 = zeros(Num, Num);
        A_Temp = A_Array{t, 1};
        E_Temp = A_Temp{1, 3};
        
        % 使用逻辑索引找到 E_Temp(i,1) 为 1 的索引
        indices = find(E_Temp(:, 1));
        
        % 对这些索引进行迭代
        for idx = indices'
            X_Carrier_Number = X1{idx, 1}';
            [X_, ~, ~, ~] = Carriers_Will_Be_Estimated_i_(idx, A_Temp, X_Carrier_Number, Sensor_Info, Num_Of_Satellite);
            X2{idx, 1} = X_;
        end
        
        % 对于 E_Temp(i,1) 不为 1 的情况，直接使用向量化操作
        X2(E_Temp(:, 1) == 0, 1) = X1(E_Temp(:, 1) == 0, 1);


        for i = 1:Num
            if ~isempty(X1{i,1})
                Where_to_Go = Find_Where_to_Go_i(i, X1{i, 1}, A_Temp); % 获取去向
                
                for j = 1:length(Where_to_Go)
                    if ~isempty(Where_to_Go{j, 1})
                        Esti_desti = Where_to_Go{j, 1};
                        Temp2(i, Esti_desti) = 1; % 向量化赋值，去除内层循环
                    end
                end
            end
        end
        
        X_All((t-2)*Num+1:(t-1)*Num, (t-1)*Num+1:t*Num) = Temp2;
        X1 = X2;

    end
    Estimation_Trans_Graph = X_All;
end