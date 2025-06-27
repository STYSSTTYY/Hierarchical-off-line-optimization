function X = The_Estimations_On_Carrier_i(Estimations)
% 把该状态下载体i上面储存的各个载体的状态估计提取出来，合并成一个矩阵X输出
%   X=[carrier1,x1,y1,z1;carrier2,x2,y2,z2;carrier3,x3,y3,z3;...]
    [~,n] = size(Estimations);
    x = [];
    X = [];
    for i = 1:n
        temp1 = 0;
        x = [];
        temp1 = sum(isnan(Estimations(:,i)));
        if temp1 ==0
            Carrier_i = i;
            x = [Carrier_i,Estimations(:,i)'];
        end
        X = [X;x];
    end
end