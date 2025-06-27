function Where_to_Go = Find_Where_to_Go_i(i,X1_i,A_Temp)
% 找出t-1时刻载体i上的状态估计在t时刻都去了哪里
    [~,b] = size(X1_i);
    Temp = cell(b,1);
    X = A_Temp{1,2};
    [~,Num] = size(X);
    Serach_Temp = X((i-1)*Num+1:i*Num,:);
    for j = 1:b
        index = find(Serach_Temp(X1_i(j),:)==1);
        if ~isempty(index)
            Temp{j,1} = index;
            Temp{j,1} = [Temp{j,1},i];
            Temp{j,1} = sort(unique(Temp{j,1}));
        else
            Temp{j,1} = i;
        end
    end
    Where_to_Go = Temp;
end