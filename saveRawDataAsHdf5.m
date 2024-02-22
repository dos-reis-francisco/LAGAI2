function saveRawDataAsHdf5(filename)

 load('RawDatas.mat','train_data', 'train_y');
 train_number=1000;
seed=2;
size_data=(seed*2+4)*(seed*2+4)*12;     
size_y=5;   %* il faut modifier la largeur de size_y pour entrer 5 

%% reshape
train_data=reshape(train_data,train_number*size_data,1);
train_y=reshape(train_y,train_number*size_y,1);
disp("Sauvegarde des données dans un fichier");
%% save datas in hdf5 file
h5create(filename,'/train_data',size_data*train_number);
h5write(filename,'/train_data',train_data);
h5create(filename,'/train_y',size_y*train_number);
h5write(filename,'/train_y',train_y);
end