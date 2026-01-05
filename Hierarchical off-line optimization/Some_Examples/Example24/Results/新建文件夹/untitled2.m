% 打开.fig文件
hFig = openfig('第二步.fig');
newText = 'Layer 3 of the fusion topology'; 

% 获取当前图形的句柄
ax = gca;
ax.Position = [0.005 0.005 0.99 0.935];

%axis tight
%axis off

currentFig = gcf;
originalPos = currentFig.Position;

% 计算新的宽度和高度，保持位置不变
newWidth = originalPos(3) *3.8/ 7;  % 宽度减半
newHeight = originalPos(4) *3.8 / 7; % 高度减半

% 设置新的位置 (保持左下角位置不变)
currentFig.Position = [originalPos(1), originalPos(2), newWidth, newHeight];
% 找到所有的text对象
textObjs = findall(hFig, 'Type', 'text');

% 遍历所有text对象，调整字号
for i = 1:length(textObjs)
    textObjs(i).FontSize = 9;  % 设置为你希望的字号
%     originalColor = textObjs(i).Color; % 获取原始颜色 (RGB)
%     
%     
%     % 更新颜色
%     textObjs(i).Color = [0.5,0.5,0.5];
end

% annotation('textbox', [0.015147368421053,0.019342105263158,0.064431578947369,0.103157894736842], 'String', '5', ...
%            'FontName', 'Times New Roman', 'FontSize', 10, ...
%            'EdgeColor', 'black', 'BackgroundColor', 'white');

% 查找所有的graphplot对象
graphObjs = findall(hFig, 'Type', 'graphplot');

% 遍历每个graphplot对象，统一修改点和边的属性
for i = 1:length(graphObjs)
    % 修改点的大小
    graphObjs(i).MarkerSize = 2;
    % 修改边的alpha值
    graphObjs(i).EdgeAlpha = 0.9;
end
% 查找所有的graphplot对象
graphObjs = findall(hFig, 'Type', 'graphplot');

% 遍历每个graphplot对象，统一调整箭头大小
for i = 1:length(graphObjs)
    % 修改边上的箭头大小
    graphObjs(i).ArrowSize = 5;
end
% 如果需要保存修改后的图，可以用saveas或savefig
%savefig(hFig, '第一步动作_改.fig');

newPos  = [135.0001303111754 204.1000012140933 0]; % 标题坐标 (pixels)

axList = findall(hFig, 'Type', 'axes');

for ax = axList(:).'                       % 转置成行向量后逐一遍历
    t  = get(ax, 'Title');                 % 取得 title 句柄
    % 若该坐标轴本来没有标题，可跳过
    if isempty(t) || isempty(t.String)
        continue
    end

    % 先设 Units，再设 Position（顺序很重要）
    set(t, ...
        'FontName',  'Times New Roman', ...   % 字体
        'String',  newText,...
        'FontSize',  9.5, ...                 % 字号 pt
        'Units',     'pixels', ...            % 单位
        'Position',  newPos);                 % 位置
end
delete(findall(hFig,'Type','legend')); 
drawnow                                   % 强制刷新