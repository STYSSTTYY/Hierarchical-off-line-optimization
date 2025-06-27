function Draw_Successful_Result(A_Array,S_Array,S_Final,outputMatrix,outputMatrix_G,outputMatrix_Cell)
% 画出成功时的结果
    
    h1 = Draw_Observation_Graph(outputMatrix,outputMatrix_G,outputMatrix_Cell);  % 绘制观测图
    %h1 = plot(outputMatrix_G,'Layout','auto');
    % 保存初始节点位置
    initialX = h1.XData;
    initialY = h1.YData;

    Steps = length(A_Array);
    Num_Of_Carriers = length(S_Array{1,1}{1,1});
    A = A_Array{end,1};
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    if (any(isnan(G)) + any(isnan(X)) + any(isnan(E))) == 3
        Steps = Steps - 1;
        S_Array = S_Array(1:end-1,1);
        A_Array = A_Array(1:end-1,1);
    end
    Result_Matrix_All = cell(Steps,1);
    Result_Matrix_Label_All = cell(Steps,1);
    Com_Cost_All = cell(Steps,1);
    Cal_Cost_All = cell(Steps,1);
    P_All = cell(Steps,1);
    for i = 1:Steps
        A = A_Array{i,1};
        S = S_Array{i+1,1};
        G = A{1,1};
        X = A{1,2};
        E = A{1,3};
        Sensor_Info = S{1,4};
        [n1,m1] = size(G);
        [n2,m2] = size(X);
        Result_Matrix = zeros(Num_Of_Carriers,Num_Of_Carriers);
        Result_Matrix_Label = cell(Num_Of_Carriers,Num_Of_Carriers);
        Com_Cost = [];
        Cal_Cost = [];
        P = [];
        for Column = 1:m1
            for Row = 1:n1
                if G(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,~,If_Relative,Dimension,~,Object] ...
                        = Extract_Corresponding_Sensor_Info(Row,Column,Sensor_Info);
                    Result_Matrix(Sender_Carrier,Receivor_Carrier) = 1;
                    if If_Relative
                        Temp = [Sender_Carrier,Object,Dimension];
                        Result_Matrix_Label{Sender_Carrier,Receivor_Carrier} = strcat(Result_Matrix_Label{Sender_Carrier,Receivor_Carrier},sprintf(' S_{%d%d-%d}',Temp));
                    else
                        Temp = Sender_Carrier;
                        Result_Matrix_Label{Sender_Carrier,Receivor_Carrier} = strcat(Result_Matrix_Label{Sender_Carrier,Receivor_Carrier},sprintf(' S_{%d}',Temp));
                    end
                end
            end
        end
        for Column = 1:m2
            for Row = 1:n2
                if X(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,Object] = Extract_Corresponding_Carrier(Row,Column,m2);
                    Result_Matrix(Sender_Carrier,Receivor_Carrier) = 1;
                    Temp = Object;
                    Result_Matrix_Label{Sender_Carrier,Receivor_Carrier} = strcat(Result_Matrix_Label{Sender_Carrier,Receivor_Carrier},sprintf(' X_{%d}',Temp));
                end
            end
        end
        if ~all(E == 0)
            for p = 1:length(E)
                if E(p,1) == 1
                    %fprintf('载体%d进行解算\n',p)
                end
            end
            %disp('                                        ')
            %disp('此时各个载体上状态如下')
            for p = 1:m1
                Cal_Capacity = S_Final{1,3}{1,1}(1,p);
                Cal_Used = S_Array{i+1,1}{1,3}{1,1}(1,p);
                Cal = [p,Cal_Used,Cal_Capacity];
                Com_Capacity = S_Final{1,3}{1,2}(1,p);
                Com_Used = S_Array{i+1,1}{1,3}{1,2}(1,p);
                Com = [p,Com_Used,Com_Capacity];
                %fprintf('载体%d运算资源量：%d/%d\n',Cal)
                %fprintf('载体%d通讯资源量：%d/%d\n',Com)
                Locations = S_Array{i+1,1}{1,2}{1,p};
                for pp = 1:m1
                    if ~any(isnan(Locations(:,pp)))
                        Location = Locations(:,pp);
                        Location = Location';
                        Cov = S_Array{i+1,1}{1,1}{1,p}((pp-1)*3+1:pp*3,(pp-1)*3+1:pp*3);
                        Temp_ = [p,pp,Location,trace(Cov)];
                        %fprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_)
                    end
                end
            end
        else
            %disp('                                        ')
            %disp('此时各个载体上状态如下')
            for p = 1:m1
                Cal_Capacity = S_Final{1,3}{1,1}(1,p);
                Cal_Used = S_Array{i+1,1}{1,3}{1,1}(1,p);
                Cal = [p,Cal_Used,Cal_Capacity];
                Com_Capacity = S_Final{1,3}{1,2}(1,p);
                Com_Used = S_Array{i+1,1}{1,3}{1,2}(1,p);
                Com = [p,Com_Used,Com_Capacity];
                %fprintf('载体%d运算资源量：%d/%d\n',Cal)
                %fprintf('载体%d通讯资源量：%d/%d\n',Com)
                Locations = S_Array{i+1,1}{1,2}{1,p};
                for pp = 1:m1
                    if ~any(isnan(Locations(:,pp)))
                        Location = Locations(:,pp);
                        Location = Location';
                        Cov = S_Array{i+1,1}{1,1}{1,p}((pp-1)*3+1:pp*3,(pp-1)*3+1:pp*3);
                        Temp_ = [p,pp,Location,trace(Cov)];
                        %fprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_)
                    end
                end
            end
        end
        %fprintf('_________________________________第%d步_________________________________\n',i)
        %disp('                                        ')
        
        Com_Cost = S_Array{i+1,1}{1,3}{1,2};
        Cal_Cost = S_Array{i+1,1}{1,3}{1,1};

        State_ = S_Array{i+1,1};
        P_All__ = Extract_Performance_Of_State(State_{1,1});  % 从当前状态中提取出所有载体上的互协方差矩阵
        P_ = Sort_Out_Best_from_all_P_Trace(P_All__);  % 从所有载体上当前存在的互协方差矩阵中整合出一个最好的代表上限，暂时只整理状态估计的方差,互协方差先不管

        for i3 = 1:Num_Of_Carriers
            P = [P,trace(P_((i3-1)*3+1:i3*3,(i3-1)*3+1:i3*3))];
        end
        
        Result_Matrix_All{i,1} = Result_Matrix;
        Result_Matrix_Label_All{i,1} = Result_Matrix_Label;
        Com_Cost_All{i,1} = Com_Cost;
        Cal_Cost_All{i,1} = Cal_Cost;
        P_All{i,1} = P;
        G2 = digraph(Result_Matrix);
        fig = figure('Color',[1,1,1], 'Position', [100, 100, 500, 400]);
        ax = axes('Parent', fig, 'Position', [0.05, 0.05, 0.9, 0.9]); % 调整轴的位置和大小
        h2 = plot(G2,'Layout','auto');
        % 应用初始图中的节点位置
        h2.XData = initialX;
        h2.YData = initialY;
        h2.LineWidth = 0.75;  % 设置线条宽度为0.75
        h2.NodeColor = 'k';  % 设置节点颜色为黑色 ('k'代表黑色)
        hold on;
        for i1 = 1:Num_Of_Carriers
            for i2 = 1:Num_Of_Carriers
                if Result_Matrix(i1,i2) ~= 0
               
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
                    edgeLabel = Result_Matrix_Label{i1,i2};
                    text_ = text(midX, midY, edgeLabel, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'FontName', 'Times New Roman', 'FontSize', 8, 'BackgroundColor', 'none');
                    uistack(text_, 'bottom');
                end
            end
        end
        s = sprintf('第%d步融合策略动作示意图',i);
        title(s, 'FontName', 'SimSun', 'FontSize', 10);
        hArrow = quiver(0, 0, 0, 0, 0, 'MaxHeadSize', 10, 'Color', [0.00,0.45,0.74], 'AutoScale', 'off', 'LineWidth', 0.75);
        hNodes = [];  % 初始化顶点图例句柄数组
        hNodes(1) = plot(NaN, NaN, 'or', 'Color', 'k', 'MarkerSize', 4, 'Marker', 'o', 'MarkerFaceColor', 'k');  % 黑色顶点
        legend([hArrow; hNodes], '观测的传输', '智能体','FontName', 'SimSun', 'FontSize', 9);
        hold off;

        

    end
    %disp('优化完成')
    Draw_Bar_Graph(Com_Cost_All,Cal_Cost_All,P_All,Steps,Num_Of_Carriers);  % 绘制直方图
end