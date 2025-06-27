function Relation_Map_ = Refresh_All_Maps(Carrier,Relation_Map,G,X,A_Array,State)
% 更新Relation_Map，重新评估各种观测和新的FC的关系
    Sensor_Info = State{1,4};
    G = Gather_All_Available_Observations(Carrier,G,X,A_Array,State);  % 把所有能用的信息都集中到载体Carrier上面了
    [a,~] = size(G);
    js = 1;
    js_ = 1;
    Sender_Carrier_ = 1;
    sum = 0;
    while js<=a
        [Sender_Carrier,~,~,~,~,~,~] ...
             = Extract_Corresponding_Sensor_Info(js,Carrier,Sensor_Info);
        if (Sender_Carrier~=Sender_Carrier_)||(js==a)
            Sender_Carrier_ = Sender_Carrier;
            if js~=a
                js = js-1;
            end
            [Sender_Carrier,Receivor_Carrier,~,~,~,~,~] ...
                 = Extract_Corresponding_Sensor_Info(js,Carrier,Sensor_Info);
            for i = js_:js
                if (G(i,Carrier)==0) % 某个观测不能用证明载体Carrier上的信息已经用过它了
                    sum = sum+1;
                end
            end
            if (Sender_Carrier~=Receivor_Carrier)
                if Relation_Map(Sender_Carrier_,Receivor_Carrier) == 4
                    Relation_Map(Sender_Carrier,Receivor_Carrier) = 4;
                elseif (sum==(js-js_+1))&&(sum~=0)
                    Relation_Map(Sender_Carrier,Receivor_Carrier) = 3;
                elseif (sum<(js-js_+1))&&(sum>0)
                    Relation_Map(Sender_Carrier,Receivor_Carrier) = 2;
                end
            end
            sum = 0;
            js_ = js+1;
            js = js+1;
        else
            js = js+1;
        end
    end

    Relation_Map_ = Relation_Map;
end