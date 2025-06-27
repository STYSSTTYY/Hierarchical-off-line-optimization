function Estimation_Trans_Graph = Build_Estimation_Trans_Graph(A_New,A_Array,S)
% 根据状态估计各个时序上的传输结合最新的动作，建立一张最新的状态估计传输矩阵。
    Time = length(A_Array);
    Sensor_Info = S{1,4};
    X_New = A_New{1,2};
    E_New = A_New{1,3};
    [n,Num] = size(X_New);
    X_Temp = zeros(n,Num);
    Fact2 = Num*Num;
    Fact1 = Fact2+Num;
    X_All = zeros((Time+1)*(Fact1),(Time+1)*(Fact1));
    A1 = A_Array{1,1};
    X_Carrier_Number = [];
    X1 = cell(Num,1);
    X2 = cell(Num,1);
    for i = 1:Num
        [X_,~,~,~] = Carriers_Will_Be_Estimated_i(i,A1,X_Carrier_Number,Sensor_Info);  % 改！
        X1{i,1} = X_;
    end
    temp1 = zeros(Num,Fact2);
    for i = 1:Num
        if ~isempty(X1{i,1})
            for j = 1:length(X1{i,1})
                temp3 = X1{i,1}(1,j);
                temp1(i,(i-1)*(Num)+temp3) = 1;
            end
        end
    end
    X_All((Fact2+1:Fact1),(1:Fact2)) = temp1;
    A_Array{Time+1,1} = A_New;
    Time = Time + 1;


    for t = 2:Time
        A_Temp = A_Array{t,1};
        E_Temp = A_Temp{1,3};
        for i = 1:Num
            if E_Temp(i,1) == 1
                X_Carrier_Number = X1{i,1}';
                [X_,~,~,~] = Carriers_Will_Be_Estimated_i(i,A_Temp,X_Carrier_Number,Sensor_Info);  % 改！
                X2{i,1} = X_;
            else
                X2{i,1} = X1{i,1};
            end
        end

        temp1 = zeros(Num,Fact2);
        for i = 1:Num
            if E_Temp(i,1) == 1
                if ~isempty(X2{i,1})
                    for j = 1:length(X2{i,1})
                        temp3 = X2{i,1}(1,j);
                        temp1(i,(i-1)*(Num)+temp3) = 1;
                    end
                end
            end
        end
        X1 = X2;
        X_All((((t-1)*(Fact1)+Fact2+1):(t*(Fact1))),(((t-1)*(Fact1)+1)): ((t-1)*(Fact1)+Fact2)) = temp1;
        X_Temp = A_Temp{1,2};


        temp2 = zeros(Fact2,Fact2);
        for  i = 1:Num
            if E_Temp(i,1) == 1
                X_All((((t-2)*(Fact1)+1):((t-2)*(Fact1)+Fact2)),(((t-1)*(Fact1)+Fact2+1):(t*(Fact1)))) = X_Temp;
            else
                for p =1:length(X1{i,1})
                    temp2(((i-1)*Num+X1{i,1}(1,p)),((i-1)*Num+X1{i,1}(1,p))) = 1;
                end
                X_All((((t-2)*(Fact1)+1):((t-2)*(Fact1)+Fact2)),(((t-1)*(Fact1)+Fact2+1):(t*(Fact1)))) = X_Temp;
            end
        end



    end
    Estimation_Trans_Graph = X_All;
end