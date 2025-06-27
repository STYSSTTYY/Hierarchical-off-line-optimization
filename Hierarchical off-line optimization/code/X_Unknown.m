function Unknown_X = X_Unknown(Unknown,X_Carrier_Number_All,Which_Has_Four_Dimension)
% 根据未知数的位置来判断该未知数属于哪个载体的状态估计,Unknown_X = [1,2,3,...];
    Unknown_X = [];
    for i = 1:length(Unknown)
        js = 0;
        temp = Unknown(1,i);
        if temp ~= 0
            for k = 1:length(X_Carrier_Number_All)
                if ismember(X_Carrier_Number_All(1,k),Which_Has_Four_Dimension)
                    js = js + 4;
                else
                    js = js + 3;
                end
                if (js >= i) 
                    Unknown_X = [Unknown_X,X_Carrier_Number_All(1,k)];
                    break;
                end
            end
        end
    end
    if ~isempty(Unknown_X)
        Unknown_X = unique(Unknown_X);
    end
end