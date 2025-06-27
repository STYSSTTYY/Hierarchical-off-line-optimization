function [state,options,optchanged] = myOutputFcn(options,state,flag)
    optchanged = false;
    persistent history % 用于存储历史最佳适应度值
    switch flag
        case 'init'
            % 初始化代码
        case 'iter'
            % 每代结束时的代码
            disp(['代数: ', num2str(state.Generation)]);
            disp(['最佳适应度值: ', num2str(state.Best(end))]);
            % 其他你想要输出的信息
        case 'done'
            % 结束代码
    end
    % 初始化历史记录
    if isempty(history)
        history = -Inf * ones(1, 3); % 假设我们检查连续3代
    end

    % 更新历史记录并检查是否满足停止条件
    if state.Generation > 0
        history = [history(2:end), state.Best(end)];
    end
    
    if state.Generation >= 3 && all(history(1:end-1) == history(end))
        %fprintf('停止条件满足：连续三代最佳适应度未改变\n');
        state.StopFlag = '连续三代最佳适应度未改变';
    end
end
