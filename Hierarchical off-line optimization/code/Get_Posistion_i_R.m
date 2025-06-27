function P_i = Get_Posistion_i_R(Carrier_i,Carrier_Position)
% 获取第i个载体的真实坐标[x,y,z]
    P = Carrier_Position(:,Carrier_i);
    P_i = P(1:3,:);
end