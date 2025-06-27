function h1 = Draw_Observation_Graph(outputMatrix,outputMatrix_G,outputMatrix_Cell)
% 绘制观测图
    [Num,~] = size(outputMatrix_Cell);
    Label_of_Graph = cell(Num,Num);
    for i1 = 1:Num
        for i2 = 1:Num
            if ~isempty(outputMatrix_Cell{i1,i2})
                L = length(outputMatrix_Cell{i1,i2});
                for k = 1:L
                    if outputMatrix_Cell{i1,i2}(k) == 0
                        Temp = i1;
                        Label_of_Graph{i1,i2} = strcat(Label_of_Graph{i1,i2},sprintf(' S_{%d}',Temp));
                    elseif outputMatrix_Cell{i1,i2}(k) == 1
                        Temp = [i1,i2,1];
                        Label_of_Graph{i1,i2} = strcat(Label_of_Graph{i1,i2},sprintf(' S_{%d%d-%d}',Temp));
                    elseif outputMatrix_Cell{i1,i2}(k) == 3
                        Temp = [i1,i2,3];
                        Label_of_Graph{i1,i2} = strcat(Label_of_Graph{i1,i2},sprintf(' S_{%d%d-%d}',Temp));
                    end
                end
            end
        end
    end
    fig = figure('Color',[1,1,1], 'Position', [100, 100, 500, 400]);
    ax = axes('Parent', fig, 'Position', [0.05, 0.05, 0.9, 0.9]); % 调整轴的位置和大小
    h1 = plot(outputMatrix_G,'Layout','auto');
    h1.LineWidth = 0.75;  % 设置线条宽度为0.75
    h1.NodeColor = 'k';  % 设置节点颜色为黑色 ('k'代表黑色)
    initialX = h1.XData;
    initialY = h1.YData;

    hold on;
    for i1 = 1:Num
        for i2 = 1:Num
            if outputMatrix(i1,i2) ~= 0
           
                % 起点和终点坐标
                startX = initialX(i1);
                startY = initialY(i1);
                endX = initialX(i2);
                endY = initialY(i2);

                % 计算控制点
                ctrlX = (startX + endX) / 2;
                ctrlY = (startY + endY) / 2;
                
                % 使用Bezier曲线公式计算中点
                t = 0.4;
                midX = (1 - t)^2 * startX + 2 * (1 - t) * t * ctrlX + t^2 * endX;
                midY = (1 - t)^2 * startY + 2 * (1 - t) * t * ctrlY + t^2 * endY;

                if (startX == endX) && (startY == endY)
                    if midX <= 0
                        midX = midX - 0.25;
                    else
                        midX = midX + 0.25;
                    end
                    if midY <= 0
                        midY = midY - 0.25;
                    else
                        midY = midY + 0.25;
                    end
                end

                % 添加标签
                edgeLabel = Label_of_Graph{i1,i2};
                text_ = text(midX, midY, edgeLabel, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontName', 'Times New Roman', 'FontSize', 8, 'BackgroundColor', 'none');
                uistack(text_, 'bottom');
            end
        end
    end
    title('智能体集群间的观测', 'FontName', 'SimSun', 'FontSize', 10);
    %hEdges = [];  % 初始化边图例句柄数组
    %hEdges = plot(NaN,NaN,'Color',[0.00,0.45,0.74] ,'LineWidth', 0.75);  % 蓝色边
    %hArrow = quiver(0, 0, 1, 0, 0, 'MaxHeadSize', 10, 'Color', [0.00,0.45,0.74], 'AutoScale', 'off', 'LineWidth', 0.75,'Visible', 'off');
    hArrow = quiver(0, 0, 0, 0, 0, 'MaxHeadSize', 0.5, 'Color', [0.00,0.45,0.74], 'AutoScale', 'off', 'LineWidth', 0.75);
    hNodes = [];  % 初始化顶点图例句柄数组
    hNodes(1) = plot(NaN, NaN, 'or', 'Color', 'k', 'MarkerSize', 4, 'Marker', 'o', 'MarkerFaceColor', 'k');  % 黑色顶点
    
    legend([hArrow; hNodes], '智能体的观测', '智能体','FontName', 'SimSun', 'FontSize', 9);
    hold off;
end