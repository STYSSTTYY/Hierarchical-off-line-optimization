[Num,~] = size(Carriers);
Com = 400000;
Cal = 100000000000;
for i = 1:Num
    if Carriers{i,2}{1,2} ~= 0
        Carriers{i,2}{1,2} = Cal;
        S_Final{1,3}{1,1}(i) = Cal;
    end
    if Carriers{i,3}{1,2} ~= 0
        Carriers{i,3}{1,2} = Com;
        S_Final{1,3}{1,2}(i) = Com;
    end
end

Pr = 5;
for i = 1:Num*3
    if ~isnan(S_Final{1,1}(i,i))
        S_Final{1,1}(i,i) = Pr;
    end
end
for j = 1:Num
    for i = 1:Num*3
        if ~isnan(S_Final{1,6}{1,j}(i,i))
            S_Final{1,6}{1,j}(i,i) = Pr;
        end
    end
end