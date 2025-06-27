function Number_List = Find_Absent_Estimations(S,Estimations_Required)
% 找到每个载体缺了哪些状态估计
    Estimations = S{1,2};
    Num = length(S{1,4});
    Estimations_On_Carriers_All = cell(Num,1);  % Estimations_On_Carriers_All每一行i代表载体i，上面是一个数组，代表载体i上有这些载体的状态估计
    Estimations_Absent_All = cell(Num,1);  % Estimations_Absent_All每一行i代表载体i，上面是一个数组，代表载体i上应该有这些载体的状态估计却缺失了
    Estimations_Absent_All_ = cell(Num,1);  % Estimations_Absent_All_每一行i代表载体i，上面是一个数组，代表载体i上应该有这些载体的状态估计
    for i = 1:Num
        X_ = The_Estimations_On_Carrier_i(Estimations{1,i});
        if ~isempty(X_)
            X_Carrier_Number = X_(:,1);
        else
            X_Carrier_Number = [];
        end
        Estimations_On_Carriers_All{i,1} = X_Carrier_Number';
    end
    [a,b] = size(Estimations_Required);
    for i = 1:a
        for j = 1:b
            if Estimations_Required(i,j) == 1  % 如果载体i的状态估计需要被载体j知晓
                Estimations_Absent_All_{j,1} = [Estimations_Absent_All_{j,1},i];
            end
        end
    end
    for i = 1:Num
        if ~isempty(Estimations_Absent_All_{i,1})
            for j = 1:length(Estimations_Absent_All_{i,1})
                if ~ismember(Estimations_Absent_All_{i,1}(1,j),Estimations_On_Carriers_All{i,1})
                    Estimations_Absent_All{i,1} = [Estimations_Absent_All{i,1},Estimations_Absent_All_{i,1}(1,j)];
                end
            end
        end
    end
    Number_List = Estimations_Absent_All;
end