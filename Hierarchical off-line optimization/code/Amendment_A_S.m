function [S_Array,A] = Amendment_A_S(S_Array_,A_,Flag_Of_Search)
%将Flag_Of_Search=2时的一种情况修正
    if (Flag_Of_Search == 2) && (~A_Is_NaN(A_))
        E_ = A_{1,3};
        [m,n] = size(E_);
        E = zeros(m,n);
        A = A_;
        A{1,3} = E;
        end1 = length(S_Array_);
        end2 = length(S_Array_{end1,1}{1,5});
        S_Array = S_Array_;
        S_Array{end1,1}{1,5}{end2,1} = A;
    else
        S_Array = S_Array_;
        A = A_;
        return;
    end
end