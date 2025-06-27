% 打开.fig文件
fig = openfig('通信消耗.fig');

% 获取条形图的句柄
bars = findobj(fig, 'Type', 'Bar');

% 修改条形图边框颜色为无色
set(bars, 'EdgeColor', 'none');

% 保存修改后的图形（可选）
savefig(fig, '通信消耗.fig');
