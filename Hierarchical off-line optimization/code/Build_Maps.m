function [Relation_Map,Observation_Map,Select_Carrier] = Build_Maps(G,X,E,State)
% 建立三种矩阵
% Relation_Map Num*Num矩阵，只记录不同载体需要哪些程度的融合信息，不记录具体在哪里融合
% Observation_Map Num*Num矩阵，只记录不同载体之间有哪些观测（绝对、相对）(i,j)代表i观测j
% Select_Carrier n*Num矩阵，记录载体的结果需要在哪里解算
    Sensor_Info = State{1,4};
    [a,Num] = size(G);
    Relation_Map = eye(Num);
    E(1,1) = 1;  % 假设将所有的信息都集中到第一个载体上来，所以仅第一个载体需要解算
    A = cell(1,3);
    for i = 1:a
        G(i,1) = 1;  % 假设将所有的信息都集中到第一个载体上来，所以第一列的传感器传输都是1
    end
    A{1,1} = G;  
    A{1,2} = X;  % 第一步时根本就没有可以传输的状态估计。
    A{1,3} = E;  
    [~,Carriers_Number,~] = Check_A_S(1,A,State);
    if ~isempty(Carriers_Number)
        for i = 1:length(Carriers_Number)
            Relation_Map(Carriers_Number(i),Carriers_Number(i)) = inf;
        end
    end
    Observation_Map = cell(Num,Num);
    for Row = 1:a
        [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
            = Extract_Corresponding_Sensor_Info(Row,1,Sensor_Info);
        if If_Relative
            Observation_Map{Sender_Carrier,Object} = [Observation_Map{Sender_Carrier,Object},Dimension];
        else
            Observation_Map{Sender_Carrier,Sender_Carrier} = [Observation_Map{Sender_Carrier,Sender_Carrier},0];
        end
    end
    Select_Carrier = zeros(1,Num);
end