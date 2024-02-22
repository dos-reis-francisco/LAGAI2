%test du format d'enregistrement hdf5 pour une récupération avec PYTHON
train_data=[[1 2 3 4 5 6 7 8 9]; [11 12 13 14 15 16 17 18 19]];
train_data=reshape(train_data,18,1);
h5create("test3.hdf5",'/train_data',18);
h5write("test3.hdf5",'/train_data',train_data);