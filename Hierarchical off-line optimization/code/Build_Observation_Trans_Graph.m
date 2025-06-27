function Observation_Trans_Graph = Build_Observation_Trans_Graph(G_New,X_New,A_Array,Sensor_Info)
% 根据相对观测和绝对观测信息各个时序上的传输结合最新的动作，建立一张最新的观测传输矩阵。
    [m,Num] = size(G_New);
    [n,~] = size(X_New);
    Time = length(A_Array);
    G_Temp = zeros(m,Num);
    G_All = zeros((Time+1)*(m+Num),(Time+1)*(m+Num));
    
    %disp('原来建图');
    for t = 1:Time
        %tic
        G_Temp = A_Array{t,1}{1,1};
        G_All(((t-1)*(m+Num)+1):((t-1)*(m+Num)+m),(((t-1)*(m+Num)+1+m)):((t-1)*(m+Num)+m+Num)) = G_Temp;
        G_All(((t-1)*(m+Num)+1):((t-1)*(m+Num)+m),((t*(m+Num)+1)):(t*(m+Num)+m)) = eye(m);
        temp = eye(Num);
        if (t + 1) > Time
            X_Temp = X_New;
        else
            X_Temp = A_Array{t+1,1}{1,2};
        end
        for j = 1:n
            for i = 1:Num
                if (X_Temp(j,i)==1)
                    for k = 1:Num
                        if ~Is_Not_Own_Estimations(j,k,Sensor_Info)
                            temp(k,i) = 1;
                            break;
                        end
                    end
                end
            end
        end
        G_All(((t-1)*(m+Num)+m+1:(t-1)*(m+Num)+m+Num),(t*(m+Num)+m+1:t*(m+Num)+m+Num)) = temp;
        %toc
    end
    G_Temp = G_New;
    % X_Temp = X_New;
    t = Time + 1;
    G_All(((t-1)*(m+Num)+1):((t-1)*(m+Num)+m),(((t-1)*(m+Num)+1+m)):((t-1)*(m+Num)+m+Num)) = G_Temp;
    Observation_Trans_Graph = G_All;
    
end