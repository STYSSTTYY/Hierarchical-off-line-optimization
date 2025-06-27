function P_Upper_Limit = Upper_Limit_Central(State,A_Array)
%检查性能能够达到的上限(不考虑代价的情况下)
    global Num_Of_Satellite;
    global Carriers_Position;
    global Satellite_Position;
    Estimations = State{1,2};
    Sensor_Info = State{1,4};
    Num = length(Sensor_Info);
    
    P_All = cell(1,Num);
    P_All_Empty = cell(1,Num);
    [a,b] = size(State{1,1}{1,1});
    for i = 1:Num
        P_All{1,i} = ones(a,b)*NaN;
        P_All_Empty{1,i} = ones(a,b)*NaN;
    end

    P_Upper_Limit_ = cell(Num,3);
    parfor i = 1:Num  % 每一个载体都要试一遍，分别把剩下的全部能用的信息集中到载体1，2，3……上
        warning('off','all');
        G = Build_Observation_Trans_Matrix(Sensor_Info);
        X = Build_Estimation_Trans_Matrix(Sensor_Info);
        Own_Estimations = The_Estimations_On_Carrier_i(Estimations{1,i});  % 假设的就是每一轮每个载体上的状态估计进入下一轮解算
        if ~isempty(Own_Estimations)
            Own_Estimations = Own_Estimations(:,1);
            Own_Estimations = Own_Estimations';
            for u = 1:length(Own_Estimations)
                X((i-1)*Num+Own_Estimations(1,u),i) = 1;  % 假设的就是每一轮每个载体上的状态估计进入下一轮解算，所以对应的X元素必须为1
            end
        end
        E = Build_Estimation_Matrix(Sensor_Info);
        G = Gather_All_Available_Observations_(i,G,X,A_Array,State,Num_Of_Satellite);  % 根据载体状态和历史动作，将剩下的观测信息中能用的都汇聚到某个载体上来
        X = Gather_All_Available_Estimations_last(i,G,X,A_Array,State,Num_Of_Satellite);  % 根据载体状态和历史动作，将剩下的别的载体的状态估计中能用的都汇聚到某个载体上来，虽然我觉得应该没了
        E = Generate_Carrier_Need_Calculating(G,X);
        A = cell(1,3);
        A{1,1} = G;  
        A{1,2} = X;  % 组合成一个新的A
        A{1,3} = E; 
        [flag,~,P] = Calculating_X_And_P_(A,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);  % 根据采取的动作和当前的状态进行解算。有解flag=1,无解flag=0
        if ~flag
            [~,Carriers_Number,X_Carrier_Number_All] = Check_A_S_(i,A,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);  % 如果解算失败的话，对应当前的A，找出是哪些应该能解算出来的载体解算不出来，如果本来理论上就没有任何载体可以被解算，那么就输出空数组。
                                                     % 上面本来采用的是函数Carriers_Number = Find_Which_Carrier_Failed(Carrier_i,A,S)
                                                     % 它采用的是纯数学方法，通过高斯约当阶梯型判断，但是由于精度原因，矩阵一大就会有玄学问题，所以就不用了
            if length(Carriers_Number) == length(X_Carrier_Number_All)  % 如果一个都解不出来的话
                %P_Upper_Limit_(end+1,:) = {i,Carriers_Number,P_All_Empty};
                P_Upper_Limit_(i,:) = {i,Carriers_Number,P_All_Empty};
            else
                [A,Carriers_Number,X_Carrier_Number_All]= Eliminate_Carrier_Cant_Solved_(Carriers_Number,X_Carrier_Number_All,i,A,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);  % 剔除所有解算不出来的载体的相关的信息，生成新的动作A以及该A对应的应该解出来的状态估计。
                [flag2,~,P] = Calculating_X_And_P_(A,State,Num_Of_Satellite,Carriers_Position,Satellite_Position);
                if flag2  
                    P_Upper_Limit_(i,:) = {i,Carriers_Number,P};
                else  % 如果最后都剔除了
                    P_Upper_Limit_(i,:) = {i,Carriers_Number,P_All_Empty};
                end
            end
        else
            P_Upper_Limit_(i,:) = {i,[],P};
        end
    end

    P_Upper_Limit = P_Upper_Limit_;
end