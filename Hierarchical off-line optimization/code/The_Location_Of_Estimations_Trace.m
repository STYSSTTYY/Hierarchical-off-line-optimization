function Estimations_Positions = The_Location_Of_Estimations_Trace(P,P_All)
% 找到性能最好的状态估计都在哪些载体上
    Num = length(P_All);
    Estimations_Positions = cell(Num,1);  % Estimations_Positions是一个元胞，它一共有Num行，代表每一个载体的状态估计，元胞内存有一数组，代表这状态估计存在于哪些载体上
    for i = 1:Num
        for j = 1:Num
            P_Now = P((i-1)*3+1:i*3,(i-1)*3+1:i*3);
            P_Tar = P_All{1,j}((i-1)*3+1:i*3,(i-1)*3+1:i*3);
            if trace(P_Now)==trace(P_Tar)
                Estimations_Positions{i,1} = [Estimations_Positions{i,1},j];
            end
        end
    end
end