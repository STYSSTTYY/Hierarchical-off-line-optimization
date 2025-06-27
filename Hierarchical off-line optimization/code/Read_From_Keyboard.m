function [Carriers,Carriers_Position,S_Final,Satellite_Position] = Read_From_Keyboard()
% 从命令行中读取Carriers,Carriers_Position,S_Final,Satellite_Position
    Carriers = Input_();
    [Carriers_Position,Satellite_Position] = Environment_(Carriers);
    S_Final = Input_Final_State(Carriers);
end