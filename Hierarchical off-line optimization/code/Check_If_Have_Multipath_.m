function [Flag,Estimation_Trans_Graph_] = Check_If_Have_Multipath_(Estimation_Trans_Graph,Num)
% 检查有向图Estimation_Trans_Graph是否存在多径，是1否0
    Flag = 0;
    [a,b] = size(Estimation_Trans_Graph);
    Estimation_Trans_Graph_ = cell(a,b);
    Fact2 = Num*Num;
    Fact1 = (Fact2+Num);
    Time = fix(a/Fact1);

    % 假设 Fact1, Fact2, Num 已经定义
    t = 1;
    row_indices = ((t-1)*Fact1+Fact2+1):(t*Fact1);
    col_indices = ((t-1)*Fact1+1):((t-1)*Fact1+Fact2);

    % 提取相关的子矩阵和单元格
    temp1 = Estimation_Trans_Graph(row_indices,col_indices);
    temp1_cell = Estimation_Trans_Graph_(row_indices,col_indices);
    [~,b2] = size(temp1);
    
    % 找到temp1中所有值为1的位置
    [rows, cols] = find(temp1 == 1);
    
    % 直接使用矢量化赋值
    for k = 1:length(rows)
        temp1_cell{rows(k),cols(k)} = [temp1_cell{rows(k),cols(k)}, rows(k)];
    end
    
    % 重新分配回原单元数组
    Estimation_Trans_Graph_(row_indices, col_indices) = temp1_cell;

    for t = 2:Time


% 预先计算可重用的索引和条件
        t2_indices = ((t-2)*Fact1+1):((t-2)*Fact1+Fact2);
        t1_indices = ((t-1)*Fact1+1):((t-1)*Fact1+Fact2);
        temp2 = Estimation_Trans_Graph(t2_indices, t1_indices);
        temp2_cell = Estimation_Trans_Graph_(t2_indices, t1_indices);
        
        % 如果t大于2，提前获取temp_
        if t > 2
            temp_ = Estimation_Trans_Graph_(((t-3)*Fact1+1):((t-3)*Fact1+Fact2), t2_indices);
        end
        
        % 逻辑索引替代双层for循环
        [rows, cols] = find(temp2 == 1);
        
        % 通过矢量化操作更新单元格
        for k = 1:length(rows)
            i = rows(k);
            j = cols(k);
            q = fix((i-1)/Num) + 1;
        
            if ~isempty(temp1_cell{q,j})
                temp2_cell{i,j} = temp1_cell{q,j};
            else
                if t > 2
                    temp2_cell{i,j} = temp_{i,j};
                else
                    temp2_cell{i,j} = temp1_cell{q,j};
                end
            end
        end
        
        % 再次分配修改后的单元数组
        Estimation_Trans_Graph_(t2_indices, t1_indices) = temp2_cell;

        % 预先计算索引
        t2_indices = ((t-2)*Fact1+1):((t-2)*Fact1+Fact2);
        t1_fact2_indices = ((t-1)*Fact1+Fact2+1):(t*Fact1);
        temp3 = Estimation_Trans_Graph(t2_indices, t1_fact2_indices);
        temp3_cell = Estimation_Trans_Graph_(t2_indices, t1_fact2_indices);
        
        % 如果t大于2，则提前获取temp_
        if t > 2
            t3_indices = ((t-3)*Fact1+1):((t-3)*Fact1+Fact2);
            t2_indices = ((t-2)*Fact1+1):((t-2)*Fact1+Fact2);
            temp_ = Estimation_Trans_Graph_(t3_indices, t2_indices);
        end
        
        % 逻辑索引替代内部的for循环
        [cols, rows] = find(temp3 == 1); % 注意这里 cols 和 rows 变量的位置是交换的，因为temp3(j,i)是在寻找列和行
        
        for k = 1:length(cols)
            j = cols(k);
            i = rows(k);
            e = fix((j-1)/Num) + 1;
        
            if ~isempty(temp1_cell{e,j})
                temp3_cell{j,i} = temp1_cell{e,j};
            else
                if t > 2
                    temp3_cell{j,i} = temp_{j,j};
                else
                    temp3_cell{j,i} = temp1_cell{e,j};
                end
            end
        end
        
        % 将修改后的单元数组重新分配
        Estimation_Trans_Graph_(t2_indices, t1_fact2_indices) = temp3_cell;
        temp1_indices = ((t-1)*Fact1+Fact2+1):(t*Fact1);
        t1_indices = ((t-1)*Fact1+1):((t-1)*Fact1+Fact2);
        temp1 = Estimation_Trans_Graph(temp1_indices, t1_indices);
        temp1_cell = Estimation_Trans_Graph_(temp1_indices, t1_indices);
        Flag = 0;

        for i = 1:Num
            for j = 1:b2
                if temp1(i,j) == 1
                    temp4 = cell(0,2); % 使用cell而不是{}
                    cols = find(temp3(:,i) == 1);
                    for u = cols'
                        temp4(end+1,:) = {u, temp3_cell{u,i}};
                    end
        
                    % Check_If_Have_Same_Tag 优化为一次性调用
                    flag = Check_If_Have_Same_Tag(temp4, Num);  % 检查某个时刻t传输到载体i上的所有状态估计是否有相同的信息来源，是1否0
                    if flag
                        Flag = 1;
                        %return; % 如果函数设计允许在这里中断执行，则可以保留这个return
                    end
                    
                    % 合并temp4中的数据并去重
                    temp = [temp4{:,2}]; % 将cell数组转换为矩阵
                    temp = unique([temp, i]);
                    temp1_cell{i,j} = temp;
                end
            end
        end
        
        % 更新Estimation_Trans_Graph_
        Estimation_Trans_Graph_(temp1_indices, t1_indices) = temp1_cell;
    end
end