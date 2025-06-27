function [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Excel(FilePath_In)
% 从Excel输入
    Path1 = strcat(FilePath_In,'\Carriers.xlsx');
    Path2 = strcat(FilePath_In,'\S_Final.xlsx');
    Num_Of_Carriers = readmatrix(Path1,'Sheet','Sheet1');
    Carriers_Excel = readmatrix(Path1,'Sheet','Sheet2');
    Carriers_SFinal_P_All = readmatrix(Path2,'Sheet','Sheet1');
    Carriers_SFinal_Position_Demanded = readmatrix(Path2,'Sheet','Sheet2');
    Carriers_SFinal_P_Divide = readcell(Path2,'Sheet','Sheet3');

    Carriers = cell(Num_Of_Carriers,5);
    Row = 0;
    for i = 1:Num_Of_Carriers
        Carriers{i,1}{1,1} = "是否是运算中心？ 1是0否";
        Carriers{i,1}{1,2} = Carriers_Excel(Row+1,1);
        Carriers{i,2}{1,1} = "它的最大算力";
        Carriers{i,2}{1,2} = Carriers_Excel(Row+1,2);
        Carriers{i,3}{1,1} = "它最大的通讯能力";
        Carriers{i,3}{1,2} = Carriers_Excel(Row+1,3);
        Carriers{i,4}{1,1} = "它装载有几个传感器";
        Carriers{i,4}{1,2} = Carriers_Excel(Row+1,4);
        Carriers{i,5}{1,1} = "它几个传感器的类型[1相对0绝对,0绝对1一维3三维,协方差,观测的载体编号(0代表不是相对观测)]";
        Carriers{i,5}{1,2} = Carriers_Excel(Row+1:Row+Carriers{i,4}{1,2},5:8);
        Row = Row + Carriers{i,4}{1,2};
    end

    [Carriers_Position,Satellite_Position] = Environment_(Carriers);

    S_Final = cell(1,6);
    S_Final{1,4} = {};
    S_Final{1,5} = {};
    S_Final{1,1} = Carriers_SFinal_P_All;
    S_Final{1,2} = Carriers_SFinal_Position_Demanded;
    Temp1 = zeros(1,Num_Of_Carriers);
    Temp2 = zeros(1,Num_Of_Carriers);
    for i = 1:Num_Of_Carriers
        Temp1(1,i) = Carriers{i,2}{1,2};
        Temp2(1,i) = Carriers{i,3}{1,2};
    end
    S_Final{1,3}{1,1} = Temp1;
    S_Final{1,3}{1,2} = Temp2;
    l = 3*Num_Of_Carriers;
    Row = 0;
    for i = 1:Num_Of_Carriers
        Row = Row + 1;
        Temp = zeros(l,l);
        for j1 = 1:l
            for j2 = 1:l
                Temp(j1,j2) = str2double(Carriers_SFinal_P_Divide{Row+j1,j2});
            end
        end
        S_Final{1,6}{1,i} = Temp;
        Row = Row + l;
    end
end