function [Relation4_New,Relation_Map_] = Find_Relation4(Est,Carrier,Relation_Map,G,G_able,X,A_Array,State,S_Final)
% 判断信息是否属于4类
    if isempty(Est)
        Relation_Map_ = Relation_Map;
        Relation4_New = [];
        return;
    end

    Relation4_New = [];
    Sensor_Info = State{1,4};
    G_i = Gather_All_Available_Observations_i_m(Est,Carrier,G,X,A_Array,State,S_Final,Relation_Map);
    [a,~] = size(G);
    Flag_4 = 0;
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
                if (G_i(i)==0)&&(ismember(Sender_Carrier,Est)) % 某个观测不能用证明载体Carrier上的信息已经用过它了
                    sum = sum+1;
                elseif (G_i(i)==1) && (G_able(i)==0)  % 或者是哪些本就解算不出来的信息
                    sum = sum+1;
                    Flag_4 = 1;
                end
            end
            if (Sender_Carrier~=Receivor_Carrier)
                if (sum==(js-js_+1))&&Flag_4&&(sum~=0)
                    Relation_Map(Sender_Carrier,Receivor_Carrier) = 4;
                elseif (sum==(js-js_+1))&&(~Flag_4)&&(sum~=0)
                    Relation_Map(Sender_Carrier,Receivor_Carrier) = 3;
                elseif (sum<(js-js_+1))&&(sum>0)
                    Relation_Map(Sender_Carrier,Receivor_Carrier) = 2;
                end
            end
            sum = 0;
            Flag_4 = 0;
            js_ = js+1;
            js = js+1;
        else
            js = js+1;
        end
    end
    for i = 1:length(Est)
        if Relation_Map(Est(i),Carrier) == 4
            Relation4_New = [Relation4_New,Est(i)];
        end
    end
    Relation4_New = sort(unique(Relation4_New));
    Relation_Map_ = Relation_Map;
end