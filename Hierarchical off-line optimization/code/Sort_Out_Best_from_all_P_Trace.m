function P_Upper_Limit_ = Sort_Out_Best_from_all_P_Trace(P_Upper_Limit)
% 从所有载体上当前存在的互协方差矩阵中整合出一个最好的代表上限，暂时只整理状态估计的方差,互协方差先不管
    Num = length(P_Upper_Limit);
    [m,~] = size(P_Upper_Limit{1,1});
    I = ones(1,Num);
    P_Upper_Limit_ = ones(m)*NaN;
    for i = 1:Num
        trace_temp = NaN;
        for i_ = 1:Num
            P_temp = P_Upper_Limit{1,i_}((i-1)*3+1:i*3,(i-1)*3+1:i*3);
            trace_Now = trace(P_temp);
            if ~isnan(trace_Now)
                if isnan(trace_temp)
                    trace_temp = trace_Now;
                    I(i) = i_;
                else
                    if trace_Now<=trace_temp
                        I(i) = i_;
                        trace_temp = trace_Now;
                    end
                end
            end
        end
    end
    for i = 1:Num
        P_Upper_Limit_((i-1)*3+1:i*3,(i-1)*3+1:i*3) = P_Upper_Limit{1,I(i)}((i-1)*3+1:i*3,(i-1)*3+1:i*3);
    end
end