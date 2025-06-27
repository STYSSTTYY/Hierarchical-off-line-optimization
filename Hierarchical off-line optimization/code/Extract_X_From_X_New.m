function [X_Of_Sender_Carrier,X_Of_Object] = Extract_X_From_X_New(Sender_Carrier,Object,X_New,X_Carrier_Number_All,Which_Has_Four_Dimension)
% 从X_New中提取对应的X(3D)
    temp1 = 0;
    flag = 0;
    X_Of_Sender_Carrier = [];
    X_Of_Object = [];
    for i = 1:length(X_Carrier_Number_All)
        for j = 1:length(Which_Has_Four_Dimension)
            if Which_Has_Four_Dimension(1,j) == X_Carrier_Number_All(1,i)
                flag = 1;
            end
        end
        if flag
            temp1 = temp1 +4;
        else
            temp1 = temp1 +3;
        end
        if X_Carrier_Number_All(1,i) == Sender_Carrier
            X_Of_Sender_Carrier = X_New((temp1 - 2 - flag):(temp1),1);
            X_Of_Sender_Carrier = X_Of_Sender_Carrier(1:3,1);
        end
        if X_Carrier_Number_All(1,i) == Object
            X_Of_Object = X_New((temp1 - 2 - flag):(temp1),1);
            X_Of_Object = X_Of_Object(1:3,1);
        end
        flag = 0;
    end
end