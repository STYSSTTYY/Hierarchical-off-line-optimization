% 打开 .fig 文件
fig = openfig('算力资源消耗直方图1500.fig', 'invisible');

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

DATA_Cal = cell(n,3);
for i = 1:n
    DATA_Cal{i,1} = bar_data(i).XData;
    DATA_Cal{i,2} = bar_data(i).YData;
    DATA_Cal{i,3} = bar_data(i).Color;
end