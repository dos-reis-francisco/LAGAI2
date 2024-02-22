%test du format d'enregistrement hdf5 pour une récupération avec PYTHON
train_data=[[1 2 3 4 5]; [6 7 8 9 10]; [11 12 13 14 15]];
train_data=transpose(train_data);
h5create("test.hdf5",'/train_data',15);
h5write("test.hdf5",'/train_data',train_data);