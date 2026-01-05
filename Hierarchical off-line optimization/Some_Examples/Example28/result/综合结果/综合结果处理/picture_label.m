% 五条竖线的 x 位置
xvals = [1, 2, 3, 4, 5];

fig = figure; 
set(fig, 'Color', 'none', 'Position', [100, 100, 330, 40]); 
hold on;  % 保持绘图
ylim([0, 1]);  % 设置 y 轴范围，方便我们在中间加文字

xline(xvals(1), '-', 'LineWidth', 0.5, 'Color', [0.05 0.05 0.05]);

% 画前三条虚线
for i = 2:4
    xline(xvals(i), '--', 'LineWidth', 0.5, 'Color', [0.5 0.5 0.5]); 
end

% 最后一条实线
xline(xvals(5), '-', 'LineWidth', 0.5, 'Color', [0.05 0.05 0.05]);

% 待会儿在四个区间处标文字
labels = {"Low", "Medium", "High", "Very High"};

% 在每对相邻 x 之间的中点处标注文字
for i = 1:4
    xmid = (xvals(i) + xvals(i+1)) / 2;  % 两条线之间的中点
    ytext = 0.5;                        % 文本在 y = 0.5 处
    text(xmid, ytext, labels{i}, ...
         'HorizontalAlignment', 'center', ...
         'FontSize', 11, ...
         'FontName', 'Times New Roman',...
         'Interpreter', 'none');
end

% 拿到当前坐标轴
ax = gca;
% 让坐标轴背景为透明
set(ax, 'Color', 'none');

% 让坐标轴完全隐藏（包括坐标轴、刻度、标签等）
axis off;

hold off;
