function [G_Temp_,X_Temp_,E_Temp_] = Retain_G_X(G_Temp,X_Temp,E_Temp,Carrier_Object_Number,Retain_Message)
% 组成这个状态估计所需的所有信息在上一时刻必须保留
    G = Retain_Message{1,1};
    X = Retain_Message{1,2};
    E = Retain_Message{1,3};
    G_logical = G == 1;
    X_logical = X == 1;
    E_logical = E == 1;

    G_Temp_ = G_Temp;
    X_Temp_ = X_Temp;
    E_Temp_ = E_Temp;

    G_Temp_{Carrier_Object_Number,1}(G_logical) = G(G_logical);
    X_Temp_{Carrier_Object_Number,1}(X_logical) = X(X_logical);
    E_Temp_{Carrier_Object_Number,1}(E_logical) = E(E_logical);

end