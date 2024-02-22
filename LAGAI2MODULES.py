# LAGAI2MODULES.py
# Bibliothèques de fonctions python pour le projet LAGAI2

import numpy as np
import h5py


def load_data(filename, number_train_samples, number_test_samples, 
              input_shape,label_shape):
    total_number=number_train_samples+number_test_samples;
    size_data=np.prod(input_shape)
    size_y=label_shape[0]

    
    # récupération des données initiales 
    datasets = h5py.File(filename, "r")
    initial_data = np.array(datasets["train_data"]) # your train set features
    initial_y = np.array(datasets["train_y"]) # your train set labels
    # génération des tableaux
    train_data=np.zeros(size_data*number_train_samples)
    train_y=np.zeros(size_y*number_train_samples)
    test_data=np.zeros(size_data*number_test_samples)
    test_y=np.zeros(size_y*number_test_samples)
    
    flag_test=np.zeros(total_number)

    for i in range(number_test_samples):
        index=int(np.ceil(total_number*np.random.rand()))-1;
        while (flag_test[index]!=0):
            index=int(np.ceil(total_number*np.random.rand()))-1;
        
        flag_test[index]=1;

    index_test=0
    index_train=0
    for i in range(total_number):
        if (flag_test[i]==0):
            train_data[index_train*size_data:(index_train+1)*size_data]=initial_data[i*size_data:(i+1)*size_data]
            train_y[index_train*size_y:(index_train+1)*size_y]=initial_y[i*size_y:(i+1)*size_y]
            index_train+=1
        else:
            test_data[index_test*size_data:(index_test+1)*size_data]=initial_data[i*size_data:(i+1)*size_data]
            test_y[index_test*size_y:(index_test+1)*size_y]=initial_y[i*size_y:(i+1)*size_y]
            index_test+=1
            
    # conversion 
    train_data=train_data.astype('float32')
    test_data=test_data.astype('float32')
    train_y=train_y.astype('float32')
    test_y=test_y.astype('float32')
    
    return train_data, train_y, test_data, test_y


def code_continu(y,number_element):
    ycode=np.zeros((number_element,5))
    ycode[:,0]=y[:,0]/6000
    ycode[:,1]=y[:,1]/6000
    ycode[:,2]=y[:,2]/2000
    ycode[:,3]=(y[:,3]+1)/2
    ycode[:,4]=y[:,4]/0.2
    return ycode

def save_data(filename,dataset_name,data_towrite):
  hf = h5py.File(filename, 'a')
  hf.create_dataset(dataset_name, data=data_towrite)
  hf.close()
