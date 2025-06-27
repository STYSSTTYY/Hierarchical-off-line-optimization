function Retain_Message = Find_What_Message_Retain(Carrier_Number,A)
% 找出组成这个状态估计所需的所有信息
    Retain_Message = cell(1,3);
    G = A{1,1};  [m1,n1] = size(G);
    X = A{1,2};  [m2,n2] = size(X);
    E = A{1,3};  [m3,n3] = size(E);
    G_ = zeros(m1,n1);
    X_ = zeros(m2,n2);
    E_ = zeros(m3,n3);
    for i = 1:m1
        G_(i,Carrier_Number) = G(i,Carrier_Number);
    end
    for i = 1:m2
        X_(i,Carrier_Number) = X(i,Carrier_Number);
    end
    E_(Carrier_Number,1) = E(Carrier_Number,1);
    Retain_Message{1,1} = G_;
    Retain_Message{1,2} = X_;
    Retain_Message{1,3} = E_;
end