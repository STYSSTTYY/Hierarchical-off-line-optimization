function [Flag,Optional_Action] = GA_New(Flag_All,G_able,G_Unable,X_i,Est,Estimations,FC_Now,G,X,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base)
% 用遗传算法实现每一步在候选载体EST中观测或者状态估计的选取
    Flag = 1; % Flag=1代表可行解存在

    Estimations_Required = S_Final{1,2};
    Estimations_Required(isnan(Estimations_Required)) = 0;
    Com_Require = (sum(Estimations_Required)+1)*Base*12;  % 一定要留足所有状态估计传进来的资源外加把自己传出去的资源

    if isempty(gcp('nocreate'))
        parpool('local',14);
    end
    
    [n_G,Num] = size(G);
    [n_X,~] = size(X);
    G_ = zeros(n_G,Num);
    X_ = zeros(n_X,Num);

    % 遗传算法参数
    nVars = n_G + n_X;  % 序列长度
    Population = 100;  % 初始种群数量

    % 指定所有变量都是整数
    IntCon = 1:nVars;

    % 设置上下界
    LB = zeros(1, nVars); % 下界为0
    UB = ones(1, nVars);  % 上界为1
    for i = 1:length(G_able)
        if G_able(i)==0
            UB(i) = 0;
        end
        if G_Unable(i)==1
            UB(i) = 0;
        end
    end
    for i = 1:length(X_i)
        if X_i(i) == 2
            LB(n_G+i) = 1;
        elseif X_i(i) == 0
            UB(n_G+i) = 0;
        end
    end
    
    js = 2;
    for i = 1:length(LB)
        if LB(i)~=UB(i)
            js = js*2;
            if js*2>100
                break;
            end
        end
    end
    if js*2<=100
        Population = js*2;
    end
    if Population <=20
        Population = 20;
    end

    % 生成初始种群
    initialPopulation = [];
    if Flag_All  % 如果理论上可以在这一轮实现精度
        for i = 1:(Population-2)/2
            randomArray_G = arrayfun(@(l, u) randsample([l, u], 1, true, [0.8,0.2]), LB(1:n_G), UB(1:n_G));  % 从0一点点往上
            randomArray_X = arrayfun(@(l, u) randsample([l, u], 1, true, [1.0,0]), LB(n_G+1:n_X+n_G), UB(n_G+1:n_X+n_G));  % 上一步状态估计存在的地方必须为1
            initialPopulation = [initialPopulation;randomArray_G,randomArray_X];
            randomArray_X = arrayfun(@(l, u) randsample([l, u], 1, true, [0.8,0.2]), LB(n_G+1:n_X+n_G), UB(n_G+1:n_X+n_G));  % 从0一点点往上
            randomArray_G = zeros(1,n_G);
            initialPopulation = [initialPopulation;randomArray_G,randomArray_X];
        end
    else
        for i = 1:(Population-2)/2
            randomArray_G = arrayfun(@(l, u) randsample([l, u], 1, true, [0.1,0.9]), LB(1:n_G), UB(1:n_G));  % 从1一点点往下
            randomArray_X = arrayfun(@(l, u) randsample([l, u], 1, true, [1.0,0]), LB(n_G+1:n_X+n_G), UB(n_G+1:n_X+n_G));  % 上一步状态估计存在的地方必须为1
            initialPopulation = [initialPopulation;randomArray_G,randomArray_X];
            randomArray_X = arrayfun(@(l, u) randsample([l, u], 1, true, [0.1,0.9]), LB(n_G+1:n_X+n_G), UB(n_G+1:n_X+n_G));  % 从1一点点往下
            randomArray_G = zeros(1,n_G);
            initialPopulation = [initialPopulation;randomArray_G,randomArray_X];
        end
    end
    randomArray_G = arrayfun(@(l, u) randsample([l, u], 1, true, [1.0,0.0]), LB(1:n_G), UB(1:n_G));  % 全0
    randomArray_X = arrayfun(@(l, u) randsample([l, u], 1, true, [1.0,0.0]), LB(n_G+1:n_X+n_G), UB(n_G+1:n_X+n_G));  % 全0
    initialPopulation = [initialPopulation;randomArray_G,randomArray_X];
    randomArray_G = arrayfun(@(l, u) randsample([l, u], 1, true, [0.0,1.0]), LB(1:n_G), UB(1:n_G));  % 全1
    randomArray_X = arrayfun(@(l, u) randsample([l, u], 1, true, [1.0,0.0]), LB(n_G+1:n_X+n_G), UB(n_G+1:n_X+n_G));  
    initialPopulation = [initialPopulation;randomArray_G,randomArray_X];

    %     try
        %fitness = baseFitnessFunction(initialPopulation(1,:),G,X,Est,Estimations,FC_Now,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base);
        % 创建匿名函数,fitness函数
        fitnessFunction = @(x) baseFitnessFunction(x,G,X,Est,Estimations,FC_Now,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base);
    
        % 启用并行计算
        options = optimoptions('ga', 'UseParallel', true, 'PopulationSize', Population, 'MaxGenerations', 20, 'InitialPopulationMatrix', initialPopulation,'OutputFcn', @myOutputFcn);
        %options = optimoptions('ga', 'UseParallel', false, 'PopulationSize', Population, 'MaxGenerations', 5, 'InitialPopulationMatrix', initialPopulation,'OutputFcn', @myOutputFcn);
        % 运行遗传算法
        [bestSequence, bestFitness] = ga(fitnessFunction, nVars, [], [], [], [], LB, UB, [], IntCon, options);

    fitness___ = baseFitnessFunction(bestSequence,G,X,Est,Estimations,FC_Now,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base);  % 全0的适应度值
    fitness = baseFitnessFunction(initialPopulation(end-1,:),G,X,Est,Estimations,FC_Now,A_Array,State,S_Final,Num_Of_Satellite,Carriers_Position,Satellite_Position,Base);  % 全0的适应度值
    
    if bestFitness==Inf  % bestFitness是负无穷代表没有找到任何可行解，意味着它算力不足了因为不论是通讯不足还是没有能用的信息，至少都可以找到一个可行解（全0）
        Flag = -1;  % Flag=-1代表算力不足
    elseif (bestFitness==fitness)&&(fitness~=Inf)
        Cost_Com_G = Com_Require(FC_Now);
        if ((Cost_Com_G + State{1,3}{1,2}(FC_Now)) <= S_Final{1,3}{1,2}(FC_Now))  % 如果这可用的消息发的出来
            Flag = 0;  %  没有可用信息能添加，意味着全是Relation4 
        else
            Flag = -2;  %  Flag=-2代表通讯不足
        end 
    end
    if Flag
        G(:,FC_Now) = bestSequence(1:n_G)'; 
        X(:,FC_Now) = bestSequence(n_G+1:n_X+n_G)';
        A_Temp = cell(1,3);
        A_Temp{1,1} = G;
        A_Temp{1,2} = X;
        A_Temp{1,3} = Generate_Carrier_Need_Calculating(G,X);
        Optional_Action = A_Temp;
    else
        Optional_Action = cell(1,3);
        Optional_Action{1,1} = zeros(n_G,Num);
        Optional_Action{1,2} = zeros(n_X,Num);
        Optional_Action{1,3} = Generate_Carrier_Need_Calculating(Optional_Action{1,1},Optional_Action{1,2});
    end
end