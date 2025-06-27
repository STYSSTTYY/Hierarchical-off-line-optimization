function [Carriers_Position,Satellite_Position] = Environment_(Carriers)
    global Num_Of_Satellite;
    Num_Of_Satellite = 13;
    Num_Of_Carriers = Find_Number_of_Carrier(Carriers);
    
    Carriers_Position = rand(3,Num_Of_Carriers)*100;
    temp1 = rand(1,Num_Of_Carriers)/10;
    Carriers_Position = [Carriers_Position;temp1];  % [x,y,z,t]
    
    Satellite_Position = rand(3,Num_Of_Satellite)*10000000;
    temp2 = rand(1,Num_Of_Satellite)/10;
    Satellite_Position = [Satellite_Position;temp2];  % [x,y,z,t]
    
    save Carriers_Position_.mat Carriers_Position;
    save Satellite_Position_.mat Satellite_Position;
end