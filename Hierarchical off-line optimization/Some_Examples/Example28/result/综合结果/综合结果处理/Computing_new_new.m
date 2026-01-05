DATA_5 = load('C:\Users\86158\Desktop\新结果图\DATA_Cal_5.mat');
DATA_667 = load('C:\Users\86158\Desktop\新结果图\DATA_Cal_6.67.mat');
DATA_83 = load('C:\Users\86158\Desktop\新结果图\DATA_Cal_8.3.mat');
DATA_15 = load('C:\Users\86158\Desktop\新结果图\DATA_Cal_15.mat');
n1 = 2; n2 = 5; n3 = 3; n4 = 2;
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
groupSpacing = 5;
interSpacing = 2;
groupPositions = zeros(groupSize, n1+n2+n3+n4);
n = n1+n2+n3+n4;
Pos = 1;
L = cell(1,n2);
for i = 1:n2
    L{1,i} = sprintf('Step %d',i);
end
for i = 1:groupSize
    for j = 1:n
        if j==n4
            groupPositions(i,j) = Pos;
            Pos = Pos + 5;
        elseif j==n4+n3
            groupPositions(i,j) = Pos;
            Pos = Pos + 4;
        elseif j==n4+n3+n2
            groupPositions(i,j) = Pos;
            Pos = Pos + interSpacing;
        elseif j==n4+n3+n2+n1
            groupPositions(i,j) = Pos;
            Pos = Pos + groupSpacing;
        else
            groupPositions(i,j) = Pos;
            Pos = Pos + 1;
        end
    end
end

fig = figure('Color',[1,1,1], 'Position', [0, 0, 650, 350]);
ax = axes('Parent', fig, 'Position', [0.05, 0.15, 0.93, 0.8]); % 调整轴的位置和大小

h1 = subplot('Position', [0.08, 0.68, 0.91, 0.22]);
% h1 = subplot('Position', [0.05, 0.43, 0.92, 0.18]);
% h1 = subplot('Position', [0.05, 0.15, 0.92, 0.18]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
%ylim([0,  50]); % 确保条形图的两端更靠近坐标轴
for i = 1:n
    W = 0.04;
    LW = 0.001;
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15.DATA_Cal{i,2}(1:9);
        k = i;
        b4(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83.DATA_Cal{i-n4,2}(1:9);
        k = i-n4;
        b3(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5.DATA_Cal{i-n4-n3-n2,2}(1:9);
        k = i-n4-n3-n2;
        b1(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667.DATA_Cal{i-n4-n3,2}(1:9);
        k = i-n4-n3;
        b2(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
        if i==(n2+n3+n4)
            legend(b2, L,'FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'best','NumColumns', ceil(n / 1), 'Units','pixels',Position=[137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736]);
        end
    end
end
hold off;  %%137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736
title('The positioning accuracy histogram ','FontName', 'Times New Roman', 'FontSize', 10);
ylabel('Accuracy (m^2)','FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(1:9, round(n/2))', 'XTickLabel', 1:1:9,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([-1,  groupPositions(9,12) + 2]); % 确保条形图的两端更靠近坐标轴




h2 = subplot('Position', [0.08, 0.40, 0.91, 0.22]);
% h1 = subplot('Position', [0.05, 0.15, 0.92, 0.18]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
%ylim([0,  50]); % 确保条形图的两端更靠近坐标轴
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15.DATA_Cal{i,2}(10:17);
        k = i;
        b4(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83.DATA_Cal{i-n4,2}(10:17);
        k = i-n4;
        b3(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5.DATA_Cal{i-n4-n3-n2,2}(10:17);
        k = i-n4-n3-n2;
        b1(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667.DATA_Cal{i-n4-n3,2}(10:17);
        k = i-n4-n3;
        b2(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
hold off;
ylabel('Accuracy (m^2)','FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(10:17, round(n/2))', 'XTickLabel', 10:1:17,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(10,1)-3,  groupPositions(17,12) + 2]); % 确保条形图的两端更靠近坐标轴


h3 = subplot('Position', [0.08, 0.12, 0.91, 0.22]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
%ylim([0,  50]); % 确保条形图的两端更靠近坐标轴
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15.DATA_Cal{i,2}(18:25);
        k = i;
        b4(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83.DATA_Cal{i-n4,2}(18:25);
        k = i-n4;
        b3(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5.DATA_Cal{i-n4-n3-n2,2}(18:25);
        k = i-n4-n3-n2;
        b1(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667.DATA_Cal{i-n4-n3,2}(18:25);
        k = i-n4-n3;
        b2(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
hold off;
ylabel('Accuracy (m^2)','FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(18:25, round(n/2))', 'XTickLabel', 18:1:25,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(18,1)-3,  groupPositions(25,12) + 2]); % 确保条形图的两端更靠近坐标轴

ylim1 = ylim(h1);
ylim2 = ylim(h2);
ylim3 = ylim(h3);

ylim_combined = [0.5*min([ylim1(1), ylim2(1), ylim3(1)]), max([ylim1(2), ylim2(2), ylim3(2)])];

ylim(h1, ylim_combined);
ylim(h2, ylim_combined);
ylim(h3, ylim_combined);

for i = groupPositions(1,1):groupPositions(9,12)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h1,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h1,[i i], ylim, 'Color', [0.1 0.1 0.1], 'LineStyle', '-');
    end
end
for i = groupPositions(10,1):groupPositions(17,12)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h2,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h2,[i i], ylim, 'Color', [0.1 0.1 0.1], 'LineStyle', '-');
    end
end
for i = groupPositions(18,1):groupPositions(25,12)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h3,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h3,[i i], ylim, 'Color', [0.1 0.1 0.1], 'LineStyle', '-');
    end
end