% 打开一个新的图形窗口
figure;

% 加载并显示第一张 .fig 图像
subplot(1, 3, 1); % 创建 1 行 3 列的子图，在第一个位置绘制
openfig('精度_修.fig'); % 加载第一张 fig 文件

% 加载并显示第二张 .fig 图像
subplot(1, 3, 2); % 在第二个位置绘制
openfig('算力消耗_修.fig'); % 加载第二张 fig 文件

% 加载并显示第三张 .fig 图像
subplot(1, 3, 3); % 在第三个位置绘制
openfig('通信消耗_修.fig'); % 加载第三张 fig 文件
