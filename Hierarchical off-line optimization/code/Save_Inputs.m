function Save_Inputs(Carriers,Carriers_Position,S_Final,Satellite_Position,FilePath)
%将键盘的输入存入指定文件夹
    folderPath = FilePath; % 将你的文件夹路径赋值给变量folderPath
    d = dir(folderPath); % 使用dir函数获取文件夹内的所有内容
    isub = [d(:).isdir]; % 返回一个逻辑向量，表示每个元素是否是文件夹
    folderCount = sum(isub)-2; % 计算文件夹数量（减2是因为dir函数的结果中包含两个特殊的目录：'.'和'..'）
    Number_Of_Folder = num2str(folderCount + 1); % 将文件夹数量存入变量A
    New_Folder_Name = strcat('\Example',Number_Of_Folder);
    New_FilePath = strcat(folderPath,New_Folder_Name);
    mkdir(New_FilePath);
    Path1 = strcat(New_FilePath,'\Carriers_.mat');
    Path2 = strcat(New_FilePath,'\Carriers_Position_.mat');
    Path3 = strcat(New_FilePath,'\S_Final_.mat');
    Path4 = strcat(New_FilePath,'\Satellite_Position_.mat');
    save (Path1,'Carriers');
    save (Path2,'Carriers_Position');
    save (Path3,'S_Final');
    save (Path4,'Satellite_Position');
end