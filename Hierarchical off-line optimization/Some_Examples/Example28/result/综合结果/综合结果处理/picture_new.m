DATA_5 = load('C:\Users\86158\Desktop\新结果图\DATA_ACC_96');
DATA_667 = load('C:\Users\86158\Desktop\新结果图\DATA_ACC_105.mat');
DATA_83 = load('C:\Users\86158\Desktop\新结果图\DATA_ACC_150.mat');
DATA_15 = load('C:\Users\86158\Desktop\新结果图\DATA_ACC_200.mat');
DATA_5_Com = load('C:\Users\86158\Desktop\新结果图\DATA_COMM_96.mat');
DATA_667_Com = load('C:\Users\86158\Desktop\新结果图\DATA_COMM_105.mat');
DATA_83_Com = load('C:\Users\86158\Desktop\新结果图\DATA_COMM_150.mat');
DATA_15_Com = load('C:\Users\86158\Desktop\新结果图\DATA_COMM_200.mat');
DATA_5_Cal = load('C:\Users\86158\Desktop\新结果图\DATA_COMP_96.mat');
DATA_667_Cal = load('C:\Users\86158\Desktop\新结果图\DATA_COMP_105.mat');
DATA_83_Cal = load('C:\Users\86158\Desktop\新结果图\DATA_COMP_150.mat');
DATA_15_Cal = load('C:\Users\86158\Desktop\新结果图\DATA_COMP_200.mat');

n1 = 5; n2 = 4; n3 = 3; n4 = 2;
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
groupSpacing = 2;
interSpacing = 3;
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

fig = figure('Color',[1,1,1], 'Position', [0, 0, 675, 799]);
ax = axes('Parent', fig, 'Position', [0.05, 0.15, 0.93, 0.8]); % 调整轴的位置和大小

h1 = subplot('Position', [0.09, 0.9, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    W = 0.04;
    LW = 0.001;
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15.DATA{i,2}(1:9);
        k = i;
        b4(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83.DATA{i-n4,2}(1:9);
        k = i-n4;
        b3(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5.DATA{i-n4-n3-n2,2}(1:9);
        k = i-n4-n3-n2;
        b1(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667.DATA{i-n4-n3,2}(1:9);
        k = i-n4-n3;
        b2(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
        if i==(n2+n3+n4)
            %legend(b2, L,'FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'best','NumColumns', ceil(n / 1), 'Units','pixels',Position=[137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736]);
        end
    end
end
Real_line_ = groupPositions(2,1) - groupPositions(1,1);
Dash_line_ = groupPositions(1,n4+1) - groupPositions(1,1);
for i = groupPositions(1,1):groupPositions(9,n1+n2+n3+n4)
    if (mod(i,Dash_line_)==0) && (mod(i,Real_line_)~=0)
        line(h1,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,Real_line_)==0
        line(h1,[i i], ylim, 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
title('The cumulative resource consumption and navigation accuracy at every layer under each requirement','FontName', 'Times New Roman', 'FontSize', 10);
hold off;  %%137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736
ylabel({'Accuracy'; '(m^2)'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'XTick', groupPositions(1:9, round(n/2))', 'XTickLabel', 1:1:9,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([-1,  groupPositions(9,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h2 = subplot('Position', [0.09, 0.795, 0.9, 0.07]);
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
        data = DATA_15_Com.DATA{i,2}(1:9);
        k = i;
        b4(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83_Com.DATA{i-n4,2}(1:9);
        k = i-n4;
        b3(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5_Com.DATA{i-n4-n3-n2,2}(1:9);
        k = i-n4-n3-n2;
        b1(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667_Com.DATA{i-n4-n3,2}(1:9);
        k = i-n4-n3;
        b2(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
        if i==(n2+n3+n4)
            %legend(b2, L,'FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'best','NumColumns', ceil(n / 1), 'Units','pixels',Position=[137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736]);
        end
    end
end
hold off;  %%137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736
ylabel({'Communica-';'tional Cost'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(1:9, round(n/2))', 'XTickLabel', 1:1:9,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([-1,  groupPositions(9,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h3 = subplot('Position', [0.09, 0.69, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    W = 0.04;
    LW = 0.001;
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15_Cal.DATA{i,2}(1:9);
        k = i;
        b4(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83_Cal.DATA{i-n4,2}(1:9);
        k = i-n4;
        b3(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5_Cal.DATA{i-n4-n3-n2,2}(1:9);
        k = i-n4-n3-n2;
        b1(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667_Cal.DATA{i-n4-n3,2}(1:9);
        k = i-n4-n3;
        b2(k) = bar(G(1:9), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
        if i==(n2+n3+n4)
            %legend(b2, L,'FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'best','NumColumns', ceil(n / 1), 'Units','pixels',Position=[137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736]);
        end
    end
end
hold off;  %%137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736
ylabel({'Computa-';'tional Cost'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(1:9, round(n/2))', 'XTickLabel', 1:1:9,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([-1,  groupPositions(9,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h4 = subplot('Position', [0.09, 0.585, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15.DATA{i,2}(10:17);
        k = i;
        b4(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83.DATA{i-n4,2}(10:17);
        k = i-n4;
        b3(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5.DATA{i-n4-n3-n2,2}(10:17);
        k = i-n4-n3-n2;
        b1(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667.DATA{i-n4-n3,2}(10:17);
        k = i-n4-n3;
        b2(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
for i = groupPositions(10,1):groupPositions(17,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h4,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h4,[i i], ylim, 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
hold off;
ylabel({'Accuracy'; '(m^2)'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'XTick', groupPositions(10:17, round(n/2))', 'XTickLabel', 10:1:17,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(10,1)-3,  groupPositions(17,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h5 = subplot('Position', [0.09, 0.48, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15_Com.DATA{i,2}(10:17);
        k = i;
        b4(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83_Com.DATA{i-n4,2}(10:17);
        k = i-n4;
        b3(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5_Com.DATA{i-n4-n3-n2,2}(10:17);
        k = i-n4-n3-n2;
        b1(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667_Com.DATA{i-n4-n3,2}(10:17);
        k = i-n4-n3;
        b2(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
hold off;
ylabel({'Communica-';'tional Cost'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(10:17, round(n/2))', 'XTickLabel', 10:1:17,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(10,1)-3,  groupPositions(17,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h6 = subplot('Position', [0.09, 0.375, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15_Cal.DATA{i,2}(10:17);
        k = i;
        b4(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83_Cal.DATA{i-n4,2}(10:17);
        k = i-n4;
        b3(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5_Cal.DATA{i-n4-n3-n2,2}(10:17);
        k = i-n4-n3-n2;
        b1(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667_Cal.DATA{i-n4-n3,2}(10:17);
        k = i-n4-n3;
        b2(k) = bar(G(10:17), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
hold off;
ylabel({'Computa-';'tional Cost'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(10:17, round(n/2))', 'XTickLabel', 10:1:17,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(10,1)-3,  groupPositions(17,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h7 = subplot('Position', [0.09, 0.27, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15.DATA{i,2}(18:25);
        k = i;
        b4(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83.DATA{i-n4,2}(18:25);
        k = i-n4;
        b3(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5.DATA{i-n4-n3-n2,2}(18:25);
        k = i-n4-n3-n2;
        b1(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667.DATA{i-n4-n3,2}(18:25);
        k = i-n4-n3;
        b2(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
for i = groupPositions(18,1):groupPositions(25,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h7,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h7,[i i], ylim, 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
hold off;
ylabel({'Accuracy'; '(m^2)'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'XTick', groupPositions(18:25, round(n/2))', 'XTickLabel', 18:1:25,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(18,1)-3,  groupPositions(25,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h8 = subplot('Position', [0.09, 0.165, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15_Com.DATA{i,2}(18:25);
        k = i;
        b4(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83_Com.DATA{i-n4,2}(18:25);
        k = i-n4;
        b3(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5_Com.DATA{i-n4-n3-n2,2}(18:25);
        k = i-n4-n3-n2;
        b1(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667_Com.DATA{i-n4-n3,2}(18:25);
        k = i-n4-n3;
        b2(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    end
end
hold off;
ylabel({'Communica-';'tional Cost'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(18:25, round(n/2))', 'XTickLabel', 18:1:25,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(18,1)-3,  groupPositions(25,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

h9 = subplot('Position', [0.09, 0.06, 0.9, 0.07]);
b1 = zeros(n1,1);
b2 = zeros(n2,1);
b3 = zeros(n3,1);
b4 = zeros(n4,1);
hold on;
for i = 1:n
    G = groupPositions(:, i)';
    if i<=n4
        data = DATA_15_Cal.DATA{i,2}(18:25);
        k = i;
        b4(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3
        data = DATA_83_Cal.DATA{i-n4,2}(18:25);
        k = i-n4;
        b3(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif (i<=n)&&(i>n4+n3+n2)
        data = DATA_5_Cal.DATA{i-n4-n3-n2,2}(18:25);
        k = i-n4-n3-n2;
        b1(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
    elseif i<=n4+n3+n2
        data = DATA_667_Cal.DATA{i-n4-n3,2}(18:25);
        k = i-n4-n3;
        b2(k) = bar(G(18:25), data, W, 'FaceColor', colors(k,:),'LineWidth',LW);
        if i==(n2+n3+n4)
            legend(b2, L,'FontName', 'Times New Roman', 'FontSize', 10, 'Location', 'best','NumColumns', ceil(n / 1), 'Units','pixels',Position=[137.0999979495999,2.133333333333348,427.0000041007996,20.000000381469736]);
        end
    end
end
hold off;
ylabel({'Computa-';'tional Cost'},'FontName', 'Times New Roman', 'FontSize', 10);
set(gca, 'YScale', 'log');
set(gca, 'XTick', groupPositions(18:25, round(n/2))', 'XTickLabel', 18:1:25,'FontName', 'Times New Roman', 'FontSize', 10);
xlim([groupPositions(18,1)-3,  groupPositions(25,n1+n2+n3+n4) + 2]); % 确保条形图的两端更靠近坐标轴

ylim1 = ylim(h2);
ylim2 = ylim(h5);
ylim3 = ylim(h8);

ylim_combined = [0.5*min([ylim1(1), ylim2(1), ylim3(1)]), max([ylim1(2), ylim2(2), ylim3(2)])];

for i = groupPositions(1,1):groupPositions(9,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h2,[i,i],[10,1000000], 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h2,[i,i],[10,1000000], 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
for i = groupPositions(10,1):groupPositions(17,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h5,[i,i],[10,1000000], 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h5,[i,i],[10,1000000], 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
for i = groupPositions(18,1):groupPositions(25,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h8,[i,i],[10,1000000], 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h8,[i,i],[10,1000000], 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end

ylim(h2, ylim_combined); 
ylim(h5, ylim_combined);
ylim(h8, ylim_combined);

ylim1 = ylim(h3);
ylim2 = ylim(h6);
ylim3 = ylim(h9);

ylim_combined = [0.01*min([ylim1(1), ylim2(1), ylim3(1)]), max([ylim1(2), ylim2(2), ylim3(2)])];

ylim(h3, ylim_combined);
set(h3,'YTick',[10000,100000000]);
ylim(h6, ylim_combined);
set(h6,'YTick',[10000,100000000]);
ylim(h9, ylim_combined);
set(h9,'YTick',[10000,100000000]);

for i = groupPositions(1,1):groupPositions(9,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h3,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h3,[i i], ylim, 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
for i = groupPositions(10,1):groupPositions(17,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h6,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h6,[i i], ylim, 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end
for i = groupPositions(18,1):groupPositions(25,n1+n2+n3+n4)
    if (mod(i,6)==0) && (mod(i,24)~=0)
        line(h9,[i i], ylim, 'Color', [0.5 0.5 0.5], 'LineStyle', '--'); 
    elseif mod(i,24)==0
        line(h9,[i i], ylim, 'Color', [0.05 0.05 0.05], 'LineStyle', '-');
    end
end