function Carriers_Number = Find_Which_Carrier_Failed2(Carrier_i,A,S,X_Carrier_Number_All)
% 有一些情况，比如互相间只有相对观测的情况，这也是解算不出来的
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    Sensor_Info = S{1,4};
    [m,Num] = size(G);
    [n,~] = size(X);
    Temp = [];
    Carriers_Number = [];
    for j = 1:n
        if X(j,Carrier_i) == 1
            [~,~,Object] = Extract_Corresponding_Carrier(j,Carrier_i,Num);
            Temp = [Temp,Object];
        end
    end
    Temp = unique(Temp);
    while 1
        Temp_ = Temp;
        for j = 1:m
            if G(j,Carrier_i) == 1
                [Sender_Carrier,~,~,If_Relative,~,~,Object] ...
                    = Extract_Corresponding_Sensor_Info(j,Carrier_i,Sensor_Info);
                if If_Relative
                    if ismember(Object,Temp_)
                        Temp_ = [Temp_,Object,Sender_Carrier];
                    elseif ismember(Sender_Carrier,Temp_)
                        Temp_ = [Temp_,Sender_Carrier,Object];
                    end
                else
                    Temp_ = [Temp_,Sender_Carrier];
                end
            end
        end
        Temp_ = unique(Temp_);
        if isequal(Temp,Temp_)
            break;
        else
            Temp = Temp_;
        end
    end
    if isempty(Temp)
        Carriers_Number = X_Carrier_Number_All;
    else
        for j = 1:length(X_Carrier_Number_All)
            if ~ismember(X_Carrier_Number_All(1,j),Temp)
                Carriers_Number = [Carriers_Number,X_Carrier_Number_All(1,j)];
            end
        end
    end
end