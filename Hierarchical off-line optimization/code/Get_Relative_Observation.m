function Observation_Relative = Get_Relative_Observation(Carrier_i,Carrier_j,Dimension,sig_square,Carrier_Position)
% 获取载体i对载体j之间指定维度的相对观测
    P_i = Get_Posistion_i_R(Carrier_i,Carrier_Position);
    P_j = Get_Posistion_i_R(Carrier_j,Carrier_Position);
    if Dimension==1
        %Observation_Relative = norm(P_j - P_i) + normrnd(0,sqrt(sig_square));  % 相对观测是j-i
        Observation_Relative = norm(P_j - P_i);
    elseif Dimension==3
        %Observation_Relative = P_j - P_i + normrnd(0,sqrt(sig_square),3,1);  % 相对观测是j-i
        Observation_Relative = P_j - P_i;
    end
end