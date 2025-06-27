function [Flag2,Carriers_Number,X_Carrier_Number_All] = Check_A_S_(i,A,S,Num_Of_Satellite,Carriers_Position,Satellite_Position)
% 根据未知数个数与方程条数的对应，找出对于运算中心i，哪些载体应该解算出来而没有解算出来，以及能不能解算出来的载体的编号，不能解算出来为1，能为0
    Flag2 = 0;
    Carriers_Number = [];
    Estimations = S{1,2};
    Sensor_Info = S{1,4};
    G = A{1,1};
    X_ = A{1,2};
    E = A{1,3};
    [m,Num] = size(G);
    [n,~] = size(X_);
    if E(i,1) == 0
        Flag2 = 1;
        Carriers_Number = [];
        X_Carrier_Number_All = [];
        return;
    end

    X = The_Estimations_On_Carrier_i(Estimations{1,i});
    if ~isempty(X)
        X_Carrier_Number = X(:,1);
    else
        X_Carrier_Number = [];
    end
    [X_Carrier_Number_All,~,~,Which_Has_Four_Dimension] = ...
        Carriers_Will_Be_Estimated_i_(i,A,X_Carrier_Number,Sensor_Info,Num_Of_Satellite);  %改！根据动作得出载体i上将要解算的观测Z的总维度，状态估计X的总维度

    Carriers_Number2 = Find_Which_Carrier_Failed2(i,A,S,X_Carrier_Number_All);  % 有一些情况，比如互相间只有相对观测的情况，下面的方法是查不出来的
    Carriers_Number3 = Find_Which_Carrier_Failed3_(i,A,S,Num_Of_Satellite,Carriers_Position,Satellite_Position);  % 改！还有一些情况

    temp = X_Carrier_Number_All;
    temp(end+1,:) = zeros(1,length(X_Carrier_Number_All));
    temp(end+1,:) = zeros(1,length(X_Carrier_Number_All));

    for j = 1:m
        if G(j,i) == 1
            [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
                = Extract_Corresponding_Sensor_Info(j,i,Sensor_Info);
            if If_Relative
                temp2 = find(X_Carrier_Number_All == Object);
                temp3 = find(X_Carrier_Number_All == Sender_Carrier);
                if ~isempty(temp2)
                    temp(2,temp2) = Dimension + temp(2,temp2);
                    temp(2,temp3) = Dimension + temp(2,temp3);
                end
            else
                temp2 = find(X_Carrier_Number_All == Sender_Carrier);
                if ~isempty(temp2)
                    temp(2,temp2) = Num_Of_Satellite + temp(2,temp2);
                    temp(3,temp2) = 1;
                end
            end
        end
    end
    for j = 1:n
        if X_(j,i) == 1
            [~,~,Object] = Extract_Corresponding_Carrier(j,i,Num);
            temp2 = find(X_Carrier_Number_All == Object);
            if ~isempty(temp2)
                temp(2,temp2) = 3 + temp(2,temp2);
            end
        end
    end
    for j = 1:length(X_Carrier_Number_All)
        if ~isempty(find(Which_Has_Four_Dimension == X_Carrier_Number_All(1,j)))
            if (temp(2,j) >= 4) && (temp(3,j) == 1)
            else
                Flag2 = 1;
                Carriers_Number = [Carriers_Number,X_Carrier_Number_All(1,j)];
            end
        else
            if temp(2,j) >=3
            else
                Flag2 = 1;
                Carriers_Number = [Carriers_Number,X_Carrier_Number_All(1,j)];
            end
        end
    end
    if ~isempty(Carriers_Number)
        Carriers_Number = unique(Carriers_Number);
    end
    if ~isempty(Carriers_Number2)
        Flag2 = 1;
        for j = 1:length(Carriers_Number2)
            if ~ismember(Carriers_Number2(1,j),Carriers_Number)
                 Carriers_Number = [Carriers_Number,Carriers_Number2(1,j)];
            end
        end
    end
    if ~isempty(Carriers_Number3)
        Flag2 = 1;
        for j = 1:length(Carriers_Number3)
            if ~ismember(Carriers_Number3(1,j),Carriers_Number)
                 Carriers_Number = [Carriers_Number,Carriers_Number3(1,j)];
            end
        end
    end
    Carriers_Number = sort(Carriers_Number);
end