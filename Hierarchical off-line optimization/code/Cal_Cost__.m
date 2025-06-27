function Cal = Cal_Cost__(A,S,Num_Of_Satellite)
% 根据采取的动作和当前的状态计算其所需运算量,而且这里是理论所需计算量，没有考虑解算不出来的情况(这是应该状态转移时考虑的),也没有考虑进一步的优化(比如让载体上某个已经达到性能要求的载体不再参与解算)
    [a,aa] = size(A{1,1});
    [b,bb] = size(A{1,2});
    if ((a==1)&&(aa==1))&&((b==1)&&(bb==1))
        if (isnan(A{1,1})) && (isnan(A{1,2}))
            Cal = S{1,3}{1,1};
            return;
        end
    end
    X_Carrier_Number = [];
    Estimations = S{1,2};
    Sensor_Info = S{1,4};
    Cost_Before = S{1,3}{1,1};
    Num = length(Sensor_Info);
    Cost = zeros(1,Num);
    E = A{1,3};  % 哪些载体要解算
    for i = 1:length(E)
        if E(i,1)==1  % 如果某一个载体此次需要解算
            X = The_Estimations_On_Carrier_i(Estimations{1,i});
            if ~isempty(X)
                X_Carrier_Number = X(:,1);
            end
            [~,Z_Dimension,X_Dimension,~] = Carriers_Will_Be_Estimated_i_(i,A,X_Carrier_Number,Sensor_Info,Num_Of_Satellite);  %改！ 根据动作得出载体i上将要解算的观测Z的总维度，状态估计X的总维度
            Size_H = [Z_Dimension,X_Dimension];
            Size_P = [Z_Dimension,Z_Dimension]; 
            Size_Z = [Z_Dimension,1];
            Size_X = [X_Dimension,1];   % H,P,Z,X矩阵的大小
            Cost(1,i) = Computation_Operand(Size_H,Size_P,Size_Z,Size_X);
        end
    end
    Cal = Cost_Before + Cost;
end