function Print_Failed_Result_Start(app)
% 输出失败时的结果
    mes = '';
    disp('很遗憾，优化失败！')
    mes = strcat(mes, '很遗憾，优化失败！\n');
    app.TextArea_7.Value = mes;
    drawnow;
end