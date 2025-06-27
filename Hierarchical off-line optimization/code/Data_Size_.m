function  data_size = Data_Size_(If_Relative,Dimension,Num_Of_Satellite,If_Sensor_Trans,Base)
% 根据传感器信息得出其传递信息的数据量，目前单位是字节
    if If_Sensor_Trans  % 如果传进来的数据来源于传感器
        if If_Relative
            data_size = Dimension*Base;  % 相对观测数据量就是维度*每个维度的字节数目
        else
            data_size = Num_Of_Satellite*Base;  % 绝对观测数据量就是卫星个数*每个卫星一个伪距观测值*每个值的字节个数
        end
    else  % 如果传进来的数据来源于状态估计
        data_size = 3*Base;  % 状态估计传的是[x,y,z]，所以数据量就是3*每个值的字节个数
    end
end