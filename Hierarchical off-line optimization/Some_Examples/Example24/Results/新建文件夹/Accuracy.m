% 打开 .fig 文件
fig = openfig('精度.fig', 'invisible');

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

groupSize = 6;

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

fig = figure('Color',[1,1,1], 'Position', [100, 100, 170, 140]);
ax = axes('Parent', fig, 'Position', [0.13, 0.17, 0.86, 0.68]); % 调整轴的位置和大小

%h1 = subplot(2, 1, 1);
b = zeros(n,1);
hold on;
for i = 1:n
    data = bar_data(i).YData(1:6);
    W = 0.15;
    G = groupPositions(:, i)';
    b(i) = bar(G(1:6), data, W, 'FaceColor', colors(i,:),'LineWidth',0.1);
end
hold off;
title('Localization Error','FontName', 'SimSun', 'FontSize', 12);
set(gca, 'XTick', groupPositions(1:6, round(n/2))', 'XTickLabel', 1:1:6,'FontSize', 9);
% set(gca, 'YScale', 'log');
ylim1 = ylim(gca);
ylim_combined = [0.5*ylim1(1), ylim1(2)];
ylim(gca, ylim_combined);
% 设置图例
legend(b, L,'FontName', 'SimSun', 'FontSize', 9, 'Location', 'best','NumColumns', ceil(n / 1), 'Position', [0.338849998359681,0.479883720453397,0.34160000328064,0.050000000953674]);