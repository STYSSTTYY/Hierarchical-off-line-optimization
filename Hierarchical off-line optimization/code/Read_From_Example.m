function [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Example(FilePath)
% 从已有文件中读取Carriers,Carriers_Position,S_Final,Satellite_Position
    Path1 = strcat(FilePath,'\Carriers_.mat');
    Path2 = strcat(FilePath,'\Carriers_Position_.mat');
    Path3 = strcat(FilePath,'\S_Final_.mat');
    Path4 = strcat(FilePath,'\Satellite_Position_.mat');
    A = load(Path1);
    Carriers = A.Carriers;
    A = load(Path2);
    Carriers_Position = A.Carriers_Position;
    A = load(Path3);
    S_Final = A.S_Final;
    A = load(Path4);
    Satellite_Position = A.Satellite_Position;
end