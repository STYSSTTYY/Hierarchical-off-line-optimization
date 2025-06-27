% 打开.fig文件
hFig = openfig('第一步动作.fig');

% 获取当前图形的句柄
ax = gca;

% 找到所有的text对象
textObjs = findall(hFig, 'Type', 'text');

% 遍历所有text对象，调整字号
for i = 1:length(textObjs)
    textObjs(i).FontSize = 16;  % 设置为你希望的字号
end

% 如果需要保存修改后的图，可以用saveas或savefig
savefig(hFig, 'example_updated.fig');
