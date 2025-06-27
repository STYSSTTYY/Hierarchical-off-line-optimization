files = dir('C:\Users\86158\Desktop\优化_搜索\优化_搜索精简\*.m');
totalLines = 0;
for i = 1:length(files)
    fid = fopen(fullfile('C:\Users\86158\Desktop\优化_搜索\优化_搜索精简', files(i).name));
    while ischar(fgets(fid))
        totalLines = totalLines + 1;
    end
    fclose(fid);
end
