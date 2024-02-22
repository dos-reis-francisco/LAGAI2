% saveHdf5database.m
% Dos Reis F.
% 26.12.2022

function saveHdf5database(filename,train_data,train_y,train_number,test_data,test_y,test_number,seed)
    size_data=(seed*2+4)*(seed*2+4)*12;
    size_y=5;
    %% save datas in hdf5 file
    h5create(filename,'/train_data',size_data*train_number);
    h5write(filename,'/train_data',train_data);
    h5create(filename,'/train_y',size_y*train_number);
    h5write(filename,'/train_y',train_y);

    h5create(filename,'/test_data',size_data*test_number);
    h5write(filename,'/test_data',test_data);
    h5create(filename,'/test_y',size_y*test_number);
    h5write(filename,'/test_y',test_y);
end