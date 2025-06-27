function Draw_Successful_Result_Start(A_Array,S_Array,S_Final,outputMatrix_G,app)
% 画出成功时的结果

    Steps = length(A_Array);

    % 更新网格布局的行数和列数
    rows = ceil((Steps+1) / 2); % 例如，2 列
    columns = 2;
    app.GridLayout3.RowHeight = repmat({200}, 1, rows);
    app.GridLayout3.ColumnWidth = repmat({'1x'}, 1, columns);

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
        for Column = 1:m1
            for Row = 1:n1
                if G(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,~,If_Relative,Dimension,~,Object] ...
                        = Extract_Corresponding_Sensor_Info(Row,Column,Sensor_Info);
                    Result_Matrix(Sender_Carrier,Receivor_Carrier) = 1;
                    if If_Relative
                        Temp = [Sender_Carrier,Sender_Carrier,Object,Dimension,Receivor_Carrier];
                        %fprintf('载体%d将相对观测Z%d%d-%d传输给载体%d\n',Temp)
                    else
                        Temp = [Sender_Carrier,Sender_Carrier,Receivor_Carrier];
                        %fprintf('载体%d将绝对观测Z%d传输给载体%d\n',Temp)
                    end
                end
            end
        end
        for Column = 1:m2
            for Row = 1:n2
                if X(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,Object] = Extract_Corresponding_Carrier(Row,Column,m2);
                    Result_Matrix(Sender_Carrier,Receivor_Carrier) = 1;
                    Temp = [Sender_Carrier,Object,Receivor_Carrier];
                    %fprintf('载体%d将状态估计X%d传输给载体%d\n',Temp)
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
        Result_Matrix_All{i,1} = Result_Matrix;
%         G2 = digraph(Result_Matrix);
%         figure(i+1);
%         h2 = plot(G2);
%         % 应用初始图中的节点位置
%         h2.XData = initialX;
%         h2.YData = initialY;
    end

    for i = 1:(Steps+1)
        if i == 1
            ax = uiaxes(app.GridLayout3);
            ax.Layout.Row = ceil(i / columns);
            ax.Layout.Column = mod(i - 1, columns) + 1;
            ax.XColor = 'none'; % 隐藏 X 轴
            ax.YColor = 'none'; % 隐藏 Y 轴
            h1 = plot(ax,outputMatrix_G);
            % 保存初始节点位置
            initialX = h1.XData;
            initialY = h1.YData;
        else
            ax = uiaxes(app.GridLayout3);
            ax.XColor = 'none'; % 隐藏 X 轴
            ax.YColor = 'none'; % 隐藏 Y 轴
            ax.Layout.Row = ceil(i / columns);
            ax.Layout.Column = mod(i - 1, columns) + 1;
            G2 = digraph(Result_Matrix_All{i-1,1});
            h2 = plot(ax,G2);
            % 应用初始图中的节点位置
            h2.XData = initialX;
            h2.YData = initialY;
            %title(ax, ['Graph ', num2str(i)]);
        end
    end
    %disp('优化完成')
end