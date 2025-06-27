function Observation_Absolute = Get_Absolute_Observation(Carrier_i,sig_square,Carrier_Position,Satellite_Position)
% 获取载体i绝对观测
    C = 299792458;
    P_i = Get_Posistion_i_A(Carrier_i,Carrier_Position);
    [~,b] = size(Satellite_Position);
    Observation_Absolute = [];
    for i = 1:b
        Rou = sqrt((Satellite_Position(1,i)-P_i(1,1))^2+(Satellite_Position(2,i)-P_i(2,1))^2+...
            (Satellite_Position(3,i)-P_i(3,1))^2) + (Satellite_Position(4,i)-P_i(4,1))*C;
        %Rou = Rou + normrnd(0,sqrt(sig_square));
        Observation_Absolute = [Observation_Absolute;Rou];
    end
end