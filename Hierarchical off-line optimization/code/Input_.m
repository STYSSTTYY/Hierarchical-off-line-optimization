function Carriers = Input_()  % 这边还要加入一下万一某个载体没有传感器的情况
    Num_Of_Carrier = input("请输入载体的数量：");
    disp("接下来请分别输入每一个载体的基本信息")
    Carriers = cell(Num_Of_Carrier,5);
    for i = 1:Num_Of_Carrier
        fprintf('_________________________________%1d_________________________________\n',i)
        fprintf('现在请输入%1d号载体的基本信息\n',i)
        If_Computing_Center = input("是否是运算中心？ 1是0否 [1]：");
        if isempty(If_Computing_Center)
            If_Computing_Center = 1;
        end
        if If_Computing_Center==1
            Computility = input("请输入它的最大算力：");
        else
            Computility = 0;
        end
        temp1 = cell(1,2);
        temp1{1,1} = "是否是运算中心？ 1是0否";
        temp1{1,2} = If_Computing_Center;
        Carriers{i,1} = temp1;
        temp1{1,1} = "它的最大算力";
        temp1{1,2} = Computility;
        Carriers{i,2} = temp1;
        Communication_Capability = input("请输入它最大的通讯能力：");
        temp1{1,1} = "它最大的通讯能力";
        temp1{1,2} = Communication_Capability;
        Carriers{i,3} = temp1;
        Num_Of_Sensor = input("请输入它装载有几个传感器：");
        Sensor_Info_ = [];
        for j = 1:Num_Of_Sensor
            fprintf('第%1d个传感器是相对观测还是绝对观测？\n',j)
            If_Relative_Observation = input("1相对观测0绝对观测 [1]：");
            if isempty(If_Relative_Observation)
                If_Relative_Observation = 1;
            end
            Object = 0;
            if If_Relative_Observation==1
                Dimension = input("这个相对观测传感器的观测是几维的？ 1一维3三维 [1]：");
                if isempty(Dimension)
                    Dimension = 1;
                end
                Object = input("这个相对观测传感器用来观测哪个载体？ （不能用来观测自己）：");
                while Object==i
                    Object = input("刚刚输入的编号和本载体一样，请问这个相对观测传感器用来观测哪个载体？ （不能用来观测自己）：");
                end
            else
                Dimension = 0;
            end
            Sigma_Square = input("这个传感器的协方差：");
            Sensor_Info = [If_Relative_Observation,Dimension,Sigma_Square,Object];
            Sensor_Info_ = [Sensor_Info_;Sensor_Info];
        end
        temp1{1,1} = "它装载有几个传感器";
        temp1{1,2} = Num_Of_Sensor;
        Carriers{i,4} = temp1;
        temp1{1,1} = "它几个传感器的类型[1相对0绝对,0绝对1一维3三维,协方差,观测的载体编号(0代表不是相对观测)]";
        temp1{1,2} = Sensor_Info_;
        Carriers{i,5} = temp1;
    end
    save Carriers_.mat Carriers;
end