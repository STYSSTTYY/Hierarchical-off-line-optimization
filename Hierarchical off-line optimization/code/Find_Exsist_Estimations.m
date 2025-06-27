function Number_List2 = Find_Exsist_Estimations(S)
% 找到每个载体存在哪些状态估计
    Estimations = S{1,2};
    Num = length(S{1,4});
    Estimations_On_Carriers_All = cell(Num,1);
    for i = 1:Num
        X_ = The_Estimations_On_Carrier_i(Estimations{1,i});
        if ~isempty(X_)
            X_Carrier_Number = X_(:,1);
        else
            X_Carrier_Number = [];
        end
        Estimations_On_Carriers_All{i,1} = X_Carrier_Number';
    end
    Number_List2 = Estimations_On_Carriers_All;
end