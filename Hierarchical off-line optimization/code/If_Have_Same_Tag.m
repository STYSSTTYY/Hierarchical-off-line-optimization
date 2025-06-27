function flag = If_Have_Same_Tag(temp1,temp2)
%判断两条观测的tag是否有重复部分，是1否0
    flag = 0;
    if isempty(temp1) || (isempty(temp2))
        flag = 0;
        return;
    end
    for i = 1:length(temp1)
        for j = 1:length(temp2)
            if temp1(1,i) == temp2(1,j)
                flag = 1;
                return;
            end
        end
    end
end