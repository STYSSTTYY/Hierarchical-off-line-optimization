% 打开 .fig 文件
fig = openfig('通信消耗.fig', 'invisible');

% 获取当前轴对象的句柄
ax = gca;

% 查找所有条形图对象（Bar objects）
bar_objs = findobj(ax, 'Type', 'Bar');

% 初始化存储数据的结构体数组
bar_data = struct('XData', [], 'YData', [], 'Color', []);
n = length(bar_objs);

% 遍历每一个条形图对象并提取数据
for i = 1:length(bar_objs)
    bar_data(n-i+1).XData = bar_objs(i).XData;
    bar_data(n-i+1).YData = bar_objs(i).YData;
    bar_data(n-i+1).Color = bar_objs(i).FaceColor; % 如果是单色条形图
end

% 关闭图形（如果不需要显示图形窗口）
close(fig);

colors = [91,155,213;
        237,125,49;
        255,192,0;
        112,173,71;
        68,114,196;
        145,208,36;
        178,53,230;
        2,174,117];
colors = colors/255;

groupSize = 25;

% 每组数据之间的间隔
groupSpacing = 3;

% 一组数据中有几条
n = length(bar_objs);

L = cell(1,n);
    for i = 1:n
        L{1,i} = sprintf('Step %d',i);
    end

% 计算每组数据在X轴上的位置
groupPositions = zeros(groupSize, n);
Pos = 1;
for i = 1:groupSize
    for j = 1:n
        if j==n
            groupPositions(i,j) = Pos;
            Pos = Pos + groupSpacing;
        else
            groupPositions(i,j) = Pos;
            Pos = Pos + 1;
        end
    end
end

fig = figure('Color',[1,1,1], 'Position', [100, 100, 500, 400]);
ax = axes('Parent', fig, 'Position', [0.1, 0.1, 0.85, 0.8]); % 调整轴的位置和大小

h1 = subplot(2, 1, 1);
b = zeros(n,1);
hold on;
for i = 1:n
    data = bar_data(i).YData(1:12);
    W = 0.15;
    G = groupPositions(:, i)';
    b(i) = bar(G(1:12), data, W, 'FaceColor', colors(i,:),'LineWidth',0.1);
end
hold off;
title('The cumulative amount of communicating resources consumption','FontName', 'SimSun', 'FontSize', 12);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(1:12, round(n/2))', 'XTickLabel', 1:1:12,'FontSize', 9);
% 设置图例
legend(b, L,'FontName', 'SimSun', 'FontSize', 9, 'Location', 'best','NumColumns', ceil(n / 1), 'Position', [0.338849998359681,0.479883720453397,0.34160000328064,0.050000000953674]);



h2 = subplot(2, 1, 2);
b = zeros(n,1);
hold on;
for i = 1:n
    data = bar_data(i).YData(13:25);
    G = groupPositions(:, i)';
    W = 0.15;
    b(i) = bar(G(13:25), data, W, 'FaceColor', colors(i,:),'LineWidth',0.1);
end
hold off;
xlabel('Number of the agent in the swarm','FontName', 'SimSun', 'FontSize', 12);
ylabel('Communicating resources consumption', 'FontName', 'SimSun', 'FontSize', 12,'Units','pixels',Position=[-24.00000032424931,160.6,0]);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(13:25, round(n/2))', 'XTickLabel', 13:1:25,'FontSize', 9);

% 获取两个子图的Y轴范围
ylim1 = ylim(h1);
ylim2 = ylim(h2);

% 计算更大的Y轴范围
ylim_combined = [0.5*min(ylim1(1), ylim2(1)), max(ylim1(2), ylim2(2))];

% 应用更大的Y轴范围到两个子图
ylim(h1, ylim_combined);
ylim(h2, ylim_combined);
% subplot(2, 1, 1);
% b = zeros(n,1);
% hold on;
% for i = 1:n
%     data = bar_data(i).YData;
%     %colors = bar_data(i).Color;
%     b(i) = bar(groupPositions(:, i)', data, 0.15, 'FaceColor', colors(i,:));
% end
% hold off;
% title('每一步各个智能体算力资源消耗直方图','FontName', 'SimSun', 'FontSize', 12);
% xlabel('集群内智能体编号','FontName', 'SimSun', 'FontSize', 10);
% ylabel('算力资源消耗','FontName', 'SimSun', 'FontSize', 10);
% set(gca, 'XTick', groupPositions(:, round(n\2))', 'XTickLabel', 1:1:groupSize,'FontSize', 9);
% % 设置图例
% legend(b, L,'FontName', 'SimSun', 'FontSize', 9, 'Location', 'best');