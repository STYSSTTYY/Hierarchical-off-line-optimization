function [A_,Carriers_Number_,X_Carrier_Number_All_]= Eliminate_Carrier_Cant_Solved_Comcentration(Carriers_Number,X_Carrier_Number_All,i,A,S)
% 剔除所有解算不出来的载体的相关的信息，生成新的动作A_以及最新的应该解出来却没解出来的载体编号Carriers_Number_
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    temp1 = G(:,i);
    temp2 = X(:,i);
    if (all(temp1 == 0)) && (all(temp2 == 0))
        A_ = A;
        Carriers_Number_ = [];
        X_Carrier_Number_All_ = [];
    elseif E(i,1) == 0
        A_ = A;
        Carriers_Number_ = [];
        X_Carrier_Number_All_ = [];
    else
        [m,Num] = size(G);
        [n,~] = size(X);
        for j = 1:m
            if G(j,i)==1
                [Sender_Carrier,~,~,If_Relative,~,~,Object] ...
                    = Extract_Corresponding_Sensor_Info(j,i,S{1,4});
                if If_Relative
                    if ismember(Object,Carriers_Number)
                        G(j,i) = 0;
                    end
                    if ismember(Sender_Carrier,Carriers_Number)
                        G(j,i) = 0;
                    end
                else
                    if ismember(Sender_Carrier,Carriers_Number)
                        G(j,i) = 0;
                    end
                end
            end
        end
        for j = 1:n
            if X(j,i) == 1
                [~,~,Object] = Extract_Corresponding_Carrier(j,i,Num);
                if ismember(Object,Carriers_Number)
                    X(j,i) = 0;
                end
            end
        end
        E = Generate_Carrier_Need_Calculating(G,X);
        for t = 1:length(E)
            if t ~= i
                E(t,1) = 0;
            end
        end
        A_ = cell(1,3);
        A_{1,1} = G;
        A_{1,2} = X;
        A_{1,3} = E;
        
        [flag,~,~] = Calculating_X_And_P_Comcentration(A_,S); % 改！
        E = Generate_Carrier_Need_Calculating(G,X);
        A_{1,3} = E;
        if flag
            for u = 1:length(Carriers_Number)
                X_Carrier_Number_All(X_Carrier_Number_All == Carriers_Number(1,u)) = [];
            end
            Carriers_Number_ = [];
            X_Carrier_Number_All_ = X_Carrier_Number_All;
        else
            [~,Carriers_Number__,X_Carrier_Number_All__] = Check_A_S_Comcentration(i,A_,S);
            [A_,Carriers_Number_,X_Carrier_Number_All_]= Eliminate_Carrier_Cant_Solved_Comcentration(Carriers_Number__,X_Carrier_Number_All__,i,A_,S);
        end
    end
end