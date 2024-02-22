% readHdf5database.m
% Dos Reis F.
% 26.12.2022
% read one data and y from a lattice database

function [data,y]=readHdf5database(name_file,name_data,name_y,number,seed)
    size_data=(seed*2+4)*(seed*2+4)*12;
    size_y=5;
    data=h5read(name_file,name_data,1,number*size_data);
    y=h5read(name_file,name_y,1,number*size_y);
end
