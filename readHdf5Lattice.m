% readHdf5.m
% read datas and y from a lattice database

function data=readHdf5Lattice(name_file,name_data,number,seed)
    size_data=(seed*2+4)*(seed*2+4)*12;
    data=h5read(name_file,name_data,(number-1)*size_data+1,size_data);
end
