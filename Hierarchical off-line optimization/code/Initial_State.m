function S_0 = Initial_State(Carriers)
% 建立初始状态
    S_0 = cell(1,5);
    Num = Find_Number_of_Carrier(Carriers);
    P = cell(1,Num);
    X = cell(1,Num);
    C = cell(1,2);
    for i = 1:Num
        p = ones(Num*3,Num*3)*NaN;
        P{1,i} = p;
        x = ones(3,Num)*NaN;  % 把t直接丢掉了
        X{1,i} = x;
    end
    C{1,1} = zeros(1,Num);
    C{1,2} = zeros(1,Num);
    S_0{1,1} = P;
    S_0{1,2} = X;
    S_0{1,3} = C;  % 代价，分别为计算代价和通讯代价
    S_0{1,4} = Carriers(:,5);  % 所有的传感器信息
    Actions_Been_Taken = {};
    S_0{1,5} = Actions_Been_Taken;
end