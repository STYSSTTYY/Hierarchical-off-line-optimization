function Print_Successful_Result(A_Array,S_Array,S_Final,Carriers)
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
    %mes = '';
    fprintf('优化成功，结果如下，一共有%d步\n',Steps)
    %mes = strcat(mes, sprintf('优化成功，结果如下，一共有%d步\n',Steps));
    disp('                                        ')
    %mes = strcat(mes, sprintf('优化成功，结果如下，一共有%d步\n',Steps));
    disp('_________________________________符号约定_________________________________')
    disp('第i个载体，标记为：载体i')
    disp('第i个载体的第k个绝对观测，标记为：Zi-k')
    disp('第i个载体对第j个载体的相对观测，是d维的，标记为：Zij-d')
    disp('第i个载体的状态估计，标记为Xi')
    disp('_________________________________符号约定_________________________________')
    disp('                                        ')
    disp('_________________________________目标状态_________________________________')
    Positions = S_Final{1,2};
    Accuracy = S_Final{1,6};
    for i = 1:Num_Of_Carriers
        for j = 1:Num_Of_Carriers
            if Positions(j,i) == 1
                Accuracy_ = Accuracy{1,i}((j-1)*3+1:j*3,(j-1)*3+1:j*3);
                Temp__ = [i,j,trace(Accuracy_)];
                fprintf('载体%d上要求存在载体%d的状态估计，精度为%f\n',Temp__)
            end
        end
    end
    disp('_________________________________目标状态_________________________________')
    disp('                                        ')
    disp('_________________________________初始状态_________________________________')
    disp('                                        ')
    fprintf('一共有%d个载体\n',Num_Of_Carriers)
    for i = 1:Num_Of_Carriers
        If_Cal_Center = Carriers{i,1}{1,2};
        Cal_Capacity = S_Final{1,3}{1,1}(1,i);
        Cal = [i,Cal_Capacity];
        Com_Capacity = S_Final{1,3}{1,2}(1,i);
        Com = [i,Com_Capacity];
        disp('                                        ')
        fprintf('#######################第%d个载体#######################\n',i)
        I = [i,i];
        fprintf('第%1d个载体，标记为：载体%d\n',I)
        if If_Cal_Center
            fprintf('第%1d个载体是运算中心\n',i)
        else
            fprintf('第%1d个载体不是运算中心\n',i)
        end
        fprintf('第%1d个载体的最大运算能力是%d\n',Cal)
        fprintf('第%1d个载体的最大通讯能力是%d\n',Com)
        Num_Of_Sensors = Carriers{i,4}{1,2};
        Sensors = [i,Num_Of_Sensors];
        fprintf('第%1d个载体装有%d个传感器，分别是\n',Sensors)
        for j = 1:Num_Of_Sensors
            Sender_Carrier = i;
            If_Relative = Carriers{i,5}{1,2}(j,1);
            Dimension = Carriers{i,5}{1,2}(j,2);
            Sig_Square = Carriers{i,5}{1,2}(j,3);
            Object = Carriers{i,5}{1,2}(j,4);
            disp('                                        ')
            fprintf('**************第%d个传感器**************\n',j)
            if If_Relative
                fprintf('第%d个传感器是相对传感器\n',j)
                fprintf('它是%d维传感器\n',Dimension)
                fprintf('它的方差为%f\n',Sig_Square)
                fprintf('它观测的对象为载体%d\n',Object)
                IJD = [i,j,Dimension];
                fprintf('标记为：Z%d%d-%d\n',IJD)
            else
                fprintf('第%d个传感器是绝对传感器\n',j)
                fprintf('它的方差为%f\n',Sig_Square)
                fprintf('标记为：Z%d\n',i)
            end
            fprintf('**************第%d个传感器**************\n',j)
            disp('                                        ')
        end
        fprintf('#######################第%d个载体#######################\n',i)
        disp('                                        ')
    end
    disp('_________________________________初始状态_________________________________')
    disp('                                        ')
    for i = 1:Steps
        A = A_Array{i,1};
        S = S_Array{i+1,1};
        G = A{1,1};
        X = A{1,2};
        E = A{1,3};
        Sensor_Info = S{1,4};
        fprintf('_________________________________第%d步_________________________________\n',i)
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
                    else
                        Temp = [Sender_Carrier,Sender_Carrier,Receivor_Carrier];
                        fprintf('载体%d将绝对观测Z%d传输给载体%d\n',Temp)
                    end
                end
            end
        end
        for Column = 1:m2
            for Row = 1:n2
                if X(Row,Column) == 1
                    [Sender_Carrier,Receivor_Carrier,Object] = Extract_Corresponding_Carrier(Row,Column,m2);
                    Temp = [Sender_Carrier,Object,Receivor_Carrier];
                    fprintf('载体%d将状态估计X%d传输给载体%d\n',Temp)
                end
            end
        end
        if ~all(E == 0)
            for p = 1:length(E)
                if E(p,1) == 1
                    fprintf('载体%d进行解算\n',p)
                end
            end
            disp('                                        ')
            disp('此时各个载体上状态如下')
            for p = 1:m1
                Cal_Capacity = S_Final{1,3}{1,1}(1,p);
                Cal_Used = S_Array{i+1,1}{1,3}{1,1}(1,p);
                Cal = [p,Cal_Used,Cal_Capacity];
                Com_Capacity = S_Final{1,3}{1,2}(1,p);
                Com_Used = S_Array{i+1,1}{1,3}{1,2}(1,p);
                Com = [p,Com_Used,Com_Capacity];
                fprintf('载体%d运算资源量：%d/%d\n',Cal)
                fprintf('载体%d通讯资源量：%d/%d\n',Com)
                Locations = S_Array{i+1,1}{1,2}{1,p};
                for pp = 1:m1
                    if ~any(isnan(Locations(:,pp)))
                        Location = Locations(:,pp);
                        Location = Location';
                        Cov = S_Array{i+1,1}{1,1}{1,p}((pp-1)*3+1:pp*3,(pp-1)*3+1:pp*3);
                        Temp_ = [p,pp,Location,trace(Cov)];
                        fprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_)
                    end
                end
            end
        else
            disp('                                        ')
            disp('此时各个载体上状态如下')
            for p = 1:m1
                Cal_Capacity = S_Final{1,3}{1,1}(1,p);
                Cal_Used = S_Array{i+1,1}{1,3}{1,1}(1,p);
                Cal = [p,Cal_Used,Cal_Capacity];
                Com_Capacity = S_Final{1,3}{1,2}(1,p);
                Com_Used = S_Array{i+1,1}{1,3}{1,2}(1,p);
                Com = [p,Com_Used,Com_Capacity];
                fprintf('载体%d运算资源量：%d/%d\n',Cal)
                fprintf('载体%d通讯资源量：%d/%d\n',Com)
                Locations = S_Array{i+1,1}{1,2}{1,p};
                for pp = 1:m1
                    if ~any(isnan(Locations(:,pp)))
                        Location = Locations(:,pp);
                        Location = Location';
                        Cov = S_Array{i+1,1}{1,1}{1,p}((pp-1)*3+1:pp*3,(pp-1)*3+1:pp*3);
                        Temp_ = [p,pp,Location,trace(Cov)];
                        fprintf('载体%d上存在载体%d的状态估计，为(%f,%f,%f)，精度为%f\n',Temp_)
                    end
                end
            end
        end
        fprintf('_________________________________第%d步_________________________________\n',i)
        disp('                                        ')
    end
    disp('优化完成')

end