function D_ = Delta_t_Multi_C_(Sender_Carrier,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension,Num_Of_Satellite,Satellite_Position)
% 伪距里面还要多减去一项dt*c
    C = 299792458;
    D_ = zeros(Num_Of_Satellite,1);
    X_Of_Sender_Carrier = ...
        Extract_X4_From_X_New(Sender_Carrier,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension);
    for i = 1:Num_Of_Satellite
        Satellite = Satellite_Position(:,i);
        D_(i,1) = C*(Satellite(4,1) - X_Of_Sender_Carrier(4,1));
    end
end