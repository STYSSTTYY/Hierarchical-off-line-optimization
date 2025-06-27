function Draw_Bar_Graph(Com_Cost_All,Cal_Cost_All,P_All,n,groupSize)
    %绘制直方图

    data = zeros(n,groupSize,3);
    for i = 1:groupSize
        for j = 1:n
            data(j,i,1) = Cal_Cost_All{j,1}(i);
            data(j,i,2) = Com_Cost_All{j,1}(i);
            data(j,i,3) = P_All{j,1}(i);
        end
    end
    
    L = cell(1,n);
    for i = 1:n
        L{1,i} = sprintf('第%d步融合策略动作',i);
    end
    
    % 生成随机颜色矩阵，每组一个颜色
    colors = [91,155,213;
        237,125,49;
        112,173,71;
        255,192,0;
        68,114,196;
        145,208,36;
        178,53,230;
        2,174,117];
    colors = colors/255;

    % 每组数据之间的间隔
    groupSpacing = round(groupSize/5);
    
    % 计算每组数据在X轴上的位置
    groupPositions = zeros(n, groupSize);
    for i = 1:n
        offset = (i-1) * (groupSize + groupSpacing);
        groupPositions(i, :) = (1:groupSize) + offset;
    end
    
    % 动态计算刻度间隔
    desiredTicks = max(min(floor(groupSize / (groupSize/10)), 3), 2); % 保证刻度在2到3个之间
    tickInterval = max(floor(groupSize / desiredTicks), 1);
    
    groupPositions_ = [];
    for i = 1:n
        groupPositions_ = [groupPositions_,groupPositions(i,1:tickInterval:end)];
    end
    
    
    % 绘制算力的直方图
    fig = figure('Color',[1,1,1], 'Position', [100, 100, 500, 400]);
    ax = axes('Parent', fig, 'Position', [0.1, 0.1, 0.85, 0.8]); % 调整轴的位置和大小
    b = zeros(n,1);
    hold on;
    for i = 1:n
        b(i) = bar(groupPositions(i, :), data(i,:,1), 0.8, 'FaceColor', colors(i,:));
    end
    hold off;
    title('每一步各个智能体算力资源消耗直方图','FontName', 'SimSun', 'FontSize', 12);
    xlabel('集群内智能体编号','FontName', 'SimSun', 'FontSize', 10);
    ylabel('算力资源消耗','FontName', 'SimSun', 'FontSize', 10);
    set(gca, 'XTick', groupPositions_, 'XTickLabel', 1:tickInterval:groupSize,'FontSize', 9);
    set(gca, 'YScale', 'log')
    % 设置图例
    legend(b, L,'FontName', 'SimSun', 'FontSize', 9, 'Location', 'best');
    
    % 绘制通信的直方图
    fig = figure('Color',[1,1,1], 'Position', [100, 100, 500, 400]);
    ax = axes('Parent', fig, 'Position', [0.1, 0.1, 0.85, 0.8]); % 调整轴的位置和大小
    b = zeros(n,1);
    hold on;
    for i = 1:n
        b(i) = bar(groupPositions(i, :), data(i,:,2), 0.8, 'FaceColor', colors(i,:));
    end
    hold off;
    title('每一步各个智能体通信资源消耗直方图','FontName', 'SimSun', 'FontSize', 12);
    xlabel('集群内智能体编号','FontName', 'SimSun', 'FontSize', 10);
    ylabel('通信资源消耗','FontName', 'SimSun', 'FontSize', 10);
    set(gca, 'XTick', groupPositions_, 'XTickLabel', 1:tickInterval:groupSize,'FontSize', 9);
    set(gca, 'YScale', 'log')
    % 设置图例
    legend(b, L,'FontName', 'SimSun', 'FontSize', 9, 'Location', 'best');
    
    % 绘制P的直方图
    fig = figure('Color',[1,1,1], 'Position', [100, 100, 500, 400]);
    ax = axes('Parent', fig, 'Position', [0.1, 0.1, 0.85, 0.8]); % 调整轴的位置和大小
    b = zeros(n,1);
    hold on;
    for i = 1:n
        b(i) = bar(groupPositions(i, :), data(i,:,3), 0.8, 'FaceColor', colors(i,:));
    end
    hold off;
    title('每一步集群内智能体定位精度直方图','FontName', 'SimSun', 'FontSize', 12);
    xlabel('集群内智能体编号','FontName', 'SimSun', 'FontSize', 10);
    ylabel('智能体定位精度','FontName', 'SimSun', 'FontSize', 10);
    set(gca, 'XTick', groupPositions_, 'XTickLabel', 1:tickInterval:groupSize,'FontSize', 9);
    % 设置图例
    legend(b, L,'FontName', 'SimSun', 'FontSize', 9, 'Location', 'best');

end