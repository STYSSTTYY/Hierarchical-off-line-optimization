function P_Require = Extract_P_Require(P_i,k)
% 提取相应载体i上面的对应状态估计k的性能要求，还是只取了方差
    top = (k-1)*3 + 1;
    bottom = k*3;
    P_Require = zeros(3,1);
    for j = top:1:bottom
        P_Require(j-top+1,1) = P_i(j,j);
    end
end