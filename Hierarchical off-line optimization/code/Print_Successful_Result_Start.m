function Print_Successful_Result_Start(A_Array,S_Array,S_Final,Carriers,app)
% 输出成功时的结果
    Steps = length(A_Array);

    Num_Of_Carriers = length(S_Array{1,1}{1,1});
    A = A_Array{end,1};
    G = A{1,1};
    X = A{1,2};
    E = A{1,3};
    if (any(isnan(G)) + any(isnan(X)) + any(isnan(E))) == 3
        Steps = Steps - 1;
        S_Array = S_Array(1:end-1,1);
        A_Array = A_Array(1:end-1,1);
    end
    mes = '';
    fprintf('优化成功，结果如下，一共有%d步\n',Steps)
    mes_ = sprintf('优化成功，结果如下，一共有%d步',Steps);
    mes = [mes newline mes_];
    %mes = strcat(mes, sprintf('优化成功，结果如下，一共有%d步\n',Steps));
    disp('                                        ')
    mes_ = '                                        ';
    mes = [mes newline mes_];
    %mes = strcat(mes,'                                        \n');
    disp('_________________________________符号约定_________________________________')
    mes_ = '______________________________符号约定______________________________';
    mes = [mes newline mes_];
    %mes = strcat(mes,'_________________________________符号约定_________________________________\n');
    disp('第i个载体，标记为：载体i')
    mes_ = '第i个载体，标记为：载体i';
    mes = [mes newline mes_];
    %mes = strcat(mes,'第i个载体，标记为：载体i\n');
    disp('第i个载体的第k个绝对观测，标记为：Zi-k')
    mes_ = '第i个载体的第k个绝对观测，标记为：Zi-k';
    mes = [mes newline mes_];
    %mes = strcat(mes,'第i个载体的第k个绝对观测，标记为：Zi-k\n');
    disp('第i个载体对第j个载体的相对观测，是d维的，标记为：Zij-d')
    mes_ = '第i个载体对第j个载体的相对观测，是d维的，标记为：Zij-d';
    mes = [mes newline mes_];
    %mes = strcat(mes,'第i个载体对第j个载体的相对观测，是d维的，标记为：Zij-d\n');
    disp('第i个载体的状态估计，标记为Xi')
    mes_ = '第i个载体的状态估计，标记为Xi';
    mes = [mes newline mes_];
    %mes = strcat(mes,'第i个载体的状态估计，标记为Xi\n');
    disp('_________________________________符号约定_________________________________')
    mes_ = '______________________________符号约定______________________________';
    mes = [mes newline mes_];
    %mes = strcat(mes,'_________________________________符号约定_________________________________\n');
    disp('                                        ')
    mes_ = '                                        ';
    mes = [mes newline mes_];
    %mes = strcat(mes,'                                        \n');
    disp('_________________________________目标状态_________________________________')
    mes_ = '______________________________目标状态______________________________';
    mes = [mes newline mes_];
    %mes = strcat(mes,'_________________________________目标状态_________________________________\n');
    app.TextArea_7.Value = '';
    app.TextArea_7.Value = mes;
    drawnow;

    Positions = S_Final{1,2};
    Accuracy = S_Final{1,6};
    for i = 1:Num_Of_Carriers
        for j = 1:Num_Of_Carriers
            if Positions(j,i) == 1
                Accuracy_ = Accuracy{1,i}((j-1)*3+1:j*3,(j-1)*3+1:j*3);
                Temp__ = [i,j,trace(Accuracy_)];
                fprintf('载体%d上要求存在载体%d的状态估计，精度为%f\n',Temp__)
                mes_ = sprintf('载体%d上要求存在载体%d的状态估计，精度为%f\n',Temp__);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('载体%d上要求存在载体%d的状态估计，精度为%f\n',Temp__));
            end
        end
    end
    app.TextArea_7.Value = '';
    app.TextArea_7.Value = mes;
    drawnow;

    disp('_________________________________目标状态_________________________________')
    mes_ = '______________________________目标状态______________________________';
    mes = [mes newline mes_];
    %mes = strcat(mes,'_________________________________目标状态_________________________________\n');
    disp('                                        ')
    mes_ = '                                        ';
    mes = [mes newline mes_];
    %mes = strcat(mes,'                                        \n');
    disp('_________________________________初始状态_________________________________')
    mes_ = '______________________________初始状态______________________________';
    mes = [mes newline mes_];
    %mes = strcat(mes,'_________________________________初始状态_________________________________\n');
    disp('                                        ')
    mes_ = '                                        ';
    mes = [mes newline mes_];
    %mes = strcat(mes,'                                        \n');
    fprintf('一共有%d个载体\n',Num_Of_Carriers)
    mes_ = sprintf('一共有%d个载体\n',Num_Of_Carriers);
    mes = [mes newline mes_];
    %mes = strcat(mes, sprintf('一共有%d个载体\n',Num_Of_Carriers));
    app.TextArea_7.Value = '';
    app.TextArea_7.Value = mes;
    drawnow;

    for i = 1:Num_Of_Carriers
        If_Cal_Center = Carriers{i,1}{1,2};
        Cal_Capacity = S_Final{1,3}{1,1}(1,i);
        Cal = [i,Cal_Capacity];
        Com_Capacity = S_Final{1,3}{1,2}(1,i);
        Com = [i,Com_Capacity];
        disp('                                        ')
        mes_ = '                                        ';
        mes = [mes newline mes_];
        %mes = strcat(mes,'                                        ');
        fprintf('#######################第%d个载体#######################\n',i)
        mes_ = sprintf('#######################第%d个载体#######################\n',i);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('#######################第%d个载体#######################\n',i));
        I = [i,i];
        fprintf('第%1d个载体，标记为：载体%d\n',I)
        mes_ = sprintf('第%1d个载体，标记为：载体%d\n',I);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('第%1d个载体，标记为：载体%d\n',I));
        if If_Cal_Center
            fprintf('第%1d个载体是运算中心\n',i)
            mes_ = sprintf('第%1d个载体是运算中心\n',i);
            mes = [mes newline mes_];
            %mes = strcat(mes, sprintf('第%1d个载体是运算中心\n',i));
        else
            fprintf('第%1d个载体不是运算中心\n',i)
            mes_ = sprintf('第%1d个载体不是运算中心\n',i);
            mes = [mes newline mes_];
            %mes = strcat(mes, sprintf('第%1d个载体不是运算中心\n',i));
        end
        fprintf('第%1d个载体的最大运算能力是%d\n',Cal)
        mes_ = sprintf('第%1d个载体的最大运算能力是%d\n',Cal);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('第%1d个载体的最大运算能力是%d\n',Cal));
        fprintf('第%1d个载体的最大通讯能力是%d\n',Com)
        mes_ = sprintf('第%1d个载体的最大通讯能力是%d\n',Com);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('第%1d个载体的最大通讯能力是%d\n',Com));
        Num_Of_Sensors = Carriers{i,4}{1,2};
        Sensors = [i,Num_Of_Sensors];
        fprintf('第%1d个载体装有%d个传感器，分别是\n',Sensors)
        mes_ = sprintf('第%1d个载体装有%d个传感器，分别是\n',Sensors);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('第%1d个载体装有%d个传感器，分别是\n',Sensors));
        app.TextArea_7.Value = '';
        app.TextArea_7.Value = mes;
        drawnow;

        for j = 1:Num_Of_Sensors
            Sender_Carrier = i;
            If_Relative = Carriers{i,5}{1,2}(j,1);
            Dimension = Carriers{i,5}{1,2}(j,2);
            Sig_Square = Carriers{i,5}{1,2}(j,3);
            Object = Carriers{i,5}{1,2}(j,4);
            disp('                                        ')
            mes_ = '                                        ';
            mes = [mes newline mes_];
            %mes = strcat(mes,'                                        \n');
            fprintf('**************第%d个传感器**************\n',j)
            mes_ = sprintf('**************第%d个传感器**************\n',j);
            mes = [mes newline mes_];
            %mes = strcat(mes, sprintf('**************第%d个传感器**************\n',j));
            if If_Relative
                fprintf('第%d个传感器是相对传感器\n',j)
                mes_ = sprintf('第%d个传感器是相对传感器\n',j);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('第%d个传感器是相对传感器\n',j));
                fprintf('它是%d维传感器\n',Dimension)
                mes_ = sprintf('它是%d维传感器\n',Dimension);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('它是%d维传感器\n',Dimension));
                fprintf('它的方差为%f\n',Sig_Square)
                mes_ = sprintf('它的方差为%f\n',Sig_Square);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('它的方差为%f\n',Sig_Square));
                fprintf('它观测的对象为载体%d\n',Object)
                mes_ = sprintf('它观测的对象为载体%d\n',Object);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('它观测的对象为载体%d\n',Object));
                IJD = [i,j,Dimension];
                fprintf('标记为：Z%d%d-%d\n',IJD)
                mes_ = sprintf('标记为：Z%d%d-%d\n',IJD);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('标记为：Z%d%d-%d\n',IJD));
            else
                fprintf('第%d个传感器是绝对传感器\n',j)
                mes_ = sprintf('第%d个传感器是绝对传感器\n',j);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('第%d个传感器是绝对传感器\n',j));
                fprintf('它的方差为%f\n',Sig_Square)
                mes_ = sprintf('它的方差为%f\n',Sig_Square);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('它的方差为%f\n',Sig_Square));
                fprintf('标记为：Z%d\n',i)
                mes_ = sprintf('标记为：Z%d\n',i);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('标记为：Z%d\n',i));
            end
            fprintf('**************第%d个传感器**************\n',j)
            mes_ = sprintf('**************第%d个传感器**************\n',j);
            mes = [mes newline mes_];
            %mes = strcat(mes, sprintf('**************第%d个传感器**************\n',j));
            disp('                                        ')
            mes_ = '                                        ';
            mes = [mes newline mes_];
            %mes = strcat(mes,'                                        \n');
            app.TextArea_7.Value = '';
            app.TextArea_7.Value = mes;
            drawnow;

        end
        fprintf('#######################第%d个载体#######################\n',i)
        mes_ = sprintf('#######################第%d个载体#######################\n',i);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('#######################第%d个载体#######################\n',i));
        disp('                                        ')
        mes_ = '                                        ';
        mes = [mes newline mes_];
        %mes = strcat(mes,'                                        \n');
        app.TextArea_7.Value = '';
        app.TextArea_7.Value = mes;
        drawnow;

    end
    disp('_________________________________初始状态_________________________________')
    mes_ = '______________________________初始状态______________________________';
    mes = [mes newline mes_];
    %mes = strcat(mes,'_________________________________初始状态_________________________________\n');
    disp('                                        ')
    mes_ = '                                        ';
    mes = [mes newline mes_];
    %mes = strcat(mes,'                                        \n');
    app.TextArea_7.Value = '';
    app.TextArea_7.Value = mes;
    drawnow;

    for i = 1:Steps
        A = A_Array{i,1};
        S = S_Array{i+1,1};
        G = A{1,1};
        X = A{1,2};
        E = A{1,3};
        Sensor_Info = S{1,4};
        fprintf('_________________________________第%d步_________________________________\n',i)
        mes_ = sprintf('______________________________第%d步______________________________\n',i);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('_________________________________第%d步_________________________________\n',i));
        [n1,m1] = size(G);
        [n2,m2] = size(X);
        for Column = 1:m1
            for Row = 1:n1
                if G(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,~,If_Relative,Dimension,~,Object] ...
                        = Extract_Corresponding_Sensor_Info(Row,Column,Sensor_Info);
                    if If_Relative
                        Temp = [Sender_Carrier,Sender_Carrier,Object,Dimension,Receivor_Carrier];
                        fprintf('载体%d将相对观测Z%d%d-%d传输给载体%d\n',Temp)
                        mes_ = sprintf('载体%d将相对观测Z%d%d-%d传输给载体%d\n',Temp);
                        mes = [mes newline mes_];
                        %mes = strcat(mes, sprintf('载体%d将相对观测Z%d%d-%d传输给载体%d\n',Temp));
                    else
                        Temp = [Sender_Carrier,Sender_Carrier,Receivor_Carrier];
                        fprintf('载体%d将绝对观测Z%d传输给载体%d\n',Temp)
                        mes_ = sprintf('载体%d将绝对观测Z%d传输给载体%d\n',Temp);
                        mes = [mes newline mes_];
                        %mes = strcat(mes, sprintf('载体%d将绝对观测Z%d传输给载体%d\n',Temp));
                    end
                end
            end
        end
        app.TextArea_7.Value = '';
        app.TextArea_7.Value = mes;
        drawnow;

        for Column = 1:m2
            for Row = 1:n2
                if X(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,Object] = Extract_Corresponding_Carrier(Row,Column,m2);
                    Temp = [Sender_Carrier,Object,Receivor_Carrier];
                    fprintf('载体%d将状态估计X%d传输给载体%d\n',Temp)
                    mes_ = sprintf('载体%d将状态估计X%d传输给载体%d\n',Temp);
                    mes = [mes newline mes_];
                    %mes = strcat(mes, sprintf('载体%d将状态估计X%d传输给载体%d\n',Temp));
                end
            end
        end
        app.TextArea_7.Value = '';
        app.TextArea_7.Value = mes;
        drawnow;

        if ~all(E == 0)
            for p = 1:length(E)
                if E(p,1) == 1
                    fprintf('载体%d进行解算\n',p)
                    mes_ = sprintf('载体%d进行解算\n',p);
                    mes = [mes newline mes_];
                    %mes = strcat(mes, sprintf('载体%d进行解算\n',p));
                end
            end
            app.TextArea_7.Value = mes;
            drawnow;

            disp('                                        ')
            mes_ = '                                        ';
            mes = [mes newline mes_];
            %mes = strcat(mes,'                                        \n');
            disp('此时各个载体上状态如下')
            mes_ = '此时各个载体上状态如下';
            mes = [mes newline mes_];
            %mes = strcat(mes,'此时各个载体上状态如下\n');
            for p = 1:m1
                Cal_Capacity = S_Final{1,3}{1,1}(1,p);
                Cal_Used = S_Array{i+1,1}{1,3}{1,1}(1,p);
                Cal = [p,Cal_Used,Cal_Capacity];
                Com_Capacity = S_Final{1,3}{1,2}(1,p);
                Com_Used = S_Array{i+1,1}{1,3}{1,2}(1,p);
                Com = [p,Com_Used,Com_Capacity];
                fprintf('载体%d运算资源量：%d/%d\n',Cal)
                mes_ = sprintf('载体%d运算资源量：%d/%d\n',Cal);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('载体%d运算资源量：%d/%d\n',Cal));
                fprintf('载体%d通讯资源量：%d/%d\n',Com)
                mes_ = sprintf('载体%d通讯资源量：%d/%d\n',Com);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('载体%d通讯资源量：%d/%d\n',Com));
                Locations = S_Array{i+1,1}{1,2}{1,p};
                for pp = 1:m1
                    if ~any(isnan(Locations(:,pp)))
                        Location = Locations(:,pp);
                        Location = Location';
                        Cov = S_Array{i+1,1}{1,1}{1,p}((pp-1)*3+1:pp*3,(pp-1)*3+1:pp*3);
                        Temp_ = [p,pp,Location,trace(Cov)];
                        fprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_)
                        mes_ = sprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_);
                        mes = [mes newline mes_];
                        %mes = strcat(mes, sprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_));
                    end
                end
                app.TextArea_7.Value = mes;
                drawnow;

            end
        else
            disp('                                        ')
            mes_ = '                                        ';
            mes = [mes newline mes_];
            %mes = strcat(mes,'                                        \n');
            disp('此时各个载体上状态如下')
            mes_ = '此时各个载体上状态如下';
            mes = [mes newline mes_];
            %mes = strcat(mes,'此时各个载体上状态如下\n');
            for p = 1:m1
                Cal_Capacity = S_Final{1,3}{1,1}(1,p);
                Cal_Used = S_Array{i+1,1}{1,3}{1,1}(1,p);
                Cal = [p,Cal_Used,Cal_Capacity];
                Com_Capacity = S_Final{1,3}{1,2}(1,p);
                Com_Used = S_Array{i+1,1}{1,3}{1,2}(1,p);
                Com = [p,Com_Used,Com_Capacity];
                fprintf('载体%d运算资源量：%d/%d\n',Cal)
                mes_ = sprintf('载体%d运算资源量：%d/%d\n',Cal);
                mes = [mes newline mes_];
                %mes = strcat(mes,sprintf('载体%d运算资源量：%d/%d\n',Cal));
                fprintf('载体%d通讯资源量：%d/%d\n',Com)
                mes_ = sprintf('载体%d通讯资源量：%d/%d\n',Com);
                mes = [mes newline mes_];
                %mes = strcat(mes, sprintf('载体%d通讯资源量：%d/%d\n',Com));
                Locations = S_Array{i+1,1}{1,2}{1,p};
                for pp = 1:m1
                    if ~any(isnan(Locations(:,pp)))
                        Location = Locations(:,pp);
                        Location = Location';
                        Cov = S_Array{i+1,1}{1,1}{1,p}((pp-1)*3+1:pp*3,(pp-1)*3+1:pp*3);
                        Temp_ = [p,pp,Location,trace(Cov)];
                        fprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_)
                        mes_ = sprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_);
                        mes = [mes newline mes_];
                        %mes = strcat(mes, sprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_));
                    end
                end
                app.TextArea_7.Value = mes;
                drawnow;

            end
        end
        fprintf('_________________________________第%d步_________________________________\n',i)
        mes_ = sprintf('______________________________第%d步______________________________\n',i);
        mes = [mes newline mes_];
        %mes = strcat(mes, sprintf('_________________________________第%d步_________________________________\n',i));
        disp('                                        ')
        mes_ = '                                        ';
        mes = [mes newline mes_];
        %mes = strcat(mes,'                                        \n');
        app.TextArea_7.Value = mes;
        drawnow;

    end
    disp('优化完成')
    mes_ = '优化完成';
    mes = [mes newline mes_];
    %mes = strcat(mes,'优化完成\n');
    app.TextArea_7.Value = mes;
    drawnow;

end