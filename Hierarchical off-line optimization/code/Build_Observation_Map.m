function [Observation_Map,outputMatrix,G] = Build_Observation_Map(State)
% 得到群相对观测的图
    Sensor_Info = State{1,4};
    G = Build_Observation_Trans_Matrix(State{1,4});
    [a,Num] = size(G);
    Observation_Map = cell(Num,Num);
    for Row = 1:a
        [Sender_Carrier,~,~,If_Relative,Dimension,~,Object] ...
            = Extract_Corresponding_Sensor_Info(Row,1,Sensor_Info);
        if If_Relative
            Observation_Map{Sender_Carrier,Object} = [Observation_Map{Sender_Carrier,Object},Dimension];
        else
            Observation_Map{Sender_Carrier,Sender_Carrier} = [Observation_Map{Sender_Carrier,Sender_Carrier},0];
        end
    end
    outputMatrix = zeros(Num, Num);
    % 使用 cellfun 判断元胞是否为空，返回一个与元胞矩阵同样大小的逻辑矩阵
    isEmptyCell = cellfun(@isempty, Observation_Map);
    % 若元胞为空，将输出矩阵对应位置设为0，否则设为1
    outputMatrix(~isEmptyCell) = 1;
    G = digraph(outputMatrix);
end