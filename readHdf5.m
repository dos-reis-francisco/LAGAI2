% readHdf5.m
% read one data and y from a lattice database

function [data,y]=readHdf5(name_file,name_data,name_y,number,seed)
    size_data=(seed*2+4)*(seed*2+4)*12;
    size_y=5;
    data=h5read(name_file,name_data,(number-1)*size_data+1,size_data);
    y=h5read(name_file,name_y,(number-1)*size_y+1,size_y);
end
