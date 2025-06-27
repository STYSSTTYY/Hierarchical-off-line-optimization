function [Dis,FC_OK__] = Choose_FC_OK(FC_OK,FC_OK_)
% 从FC_OK里面挑一个
    if ~isempty(FC_OK_)
        permutedIndices = randperm(length(FC_OK_));
    
        % 选择索引数组的第一个元素
        selectedElementIndex = permutedIndices(1);
        Dis = FC_OK_(selectedElementIndex);
        
        % 从原始数组中删除相应的元素
        FC_OK_(selectedElementIndex) = [];
    else
        permutedIndices = randperm(length(FC_OK));
    
        % 选择索引数组的第一个元素
        selectedElementIndex = permutedIndices(1);
        Dis = FC_OK(selectedElementIndex);
    end
    FC_OK__ = FC_OK_;
end