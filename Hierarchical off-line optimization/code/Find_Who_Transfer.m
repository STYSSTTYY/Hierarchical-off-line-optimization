function Carrier_k = Find_Who_Transfer(Carrier_Object_Number,Carrier_Number,X)
% 找出谁传给载体Carrier_Number的，假设是载体Carrier_k
    [m,n] = size(X);
    Carrier_k = [];
    for i = 1:m
        if X(i,Carrier_Number) == 1
            Carrier = mod(i-1,n) + 1;
            if Carrier == Carrier_Object_Number
                Carrier_k = fix((i-1)/n) + 1;
            end
        end
    end
end