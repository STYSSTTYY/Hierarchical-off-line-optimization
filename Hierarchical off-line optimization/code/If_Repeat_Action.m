function Flag_Of_Search_ = If_Repeat_Action(Action_Now,State,Flag_Of_Search)
%检查该动作是否之前出现过
    if Flag_Of_Search==0
        Flag_Of_Search_ = 0;
        return;
    end
    n = length(State{1,5});
    if (n<=1)&&(Flag_Of_Search~=0)
        if Flag_Of_Search == 2
            Flag_Of_Search_ = 2;
        else
            Flag_Of_Search_ = 1;
        end
        return;
    end
    Action_Before = State{1,5}{end,1};
    G_Before = Action_Before{1,1};
    X_Before = Action_Before{1,2};
    G_Now = Action_Now{1,1};
    X_Now = Action_Now{1,2};
    if isequal(G_Before,G_Now)&&isequal(X_Before,X_Now)
        Flag_Of_Search_ = 0;
    end
end