#import libraries

import tensorflow as tf
import tensorflow.keras as keras
import time
from tensorflow.keras.layers import Dense, Input
from tensorflow.keras.layers import Conv2D, Conv3D, Flatten, Lambda
from tensorflow.keras.layers import Reshape, Conv2DTranspose, Conv3DTranspose
from tensorflow.keras.layers import concatenate
from tensorflow.keras.models import Model
from tensorflow.keras.losses import mse, binary_crossentropy
from tensorflow.keras.utils import plot_model
from tensorflow.keras import backend as K
from tensorflow.python.client import device_lib
import numpy as np
import matplotlib.pyplot as plt
import argparse
import os
import h5py
import datetime
import LAGAI2MODULES as L2M
import matlab.engine

fileDatabase='database24.h5'
number_element=100000
filename_decoded='data24_decoded.h5'
filename_cloud_data_NN='database24_NN.h5'
number_points_NN_cloud=10000

MechDesired=np.array([15000,15000,4000,0.3,0.2,\
                      15000,7000,4000,0.3,0.2,\
                      7000,15000,4000,0.3,0.2,\
                      2000,2000,6000,0.6,0.1,\
                      4000,4000,1000,-0.4,0.1,\
                      10000,10000,10000,0.3,0.15,\
                      3000,3000,1000,0.3,0.05])
nMechDesired=int(MechDesired.shape[0]/5)

model_name = "LAGAI2_decoder"
save_dir = "decoder_weights"

# network parameters
# input_shape = (raws, columns, depth, layers) 

batch_size = 128
kernel_size = 3
filters = 16
latent_dim = 2
epochs = 30

input_shape =(8,8,12,1)
label_shape=(5,)


# output directory
output_dir="./output"+datetime.datetime.now().strftime("%Y%m%d%H%M%S")+"/"

os.makedirs(output_dir, exist_ok=True)

# build decoder model

inputs = Input(shape=input_shape, name='decoder_input')
y_labels = Input(shape=label_shape, name='mechanical_values')

shape=np.array([0,2,2,3,64]) # shape of the first layer of the decoder (to be modified)
                             # shape[0] is the number of images to be generated
                             # shape[1] is the number of rows * 2 --> 2x upsampling --> 8
                             # shape[2] is the number of columns * 2 --> 2x upsampling --> 8
                             # shape[3] is the number of channels * 4 --> 4x upsampling --> 12
                             # in final the matrix is 8x8x12
x = Dense(shape[1]*shape[2]*shape[3]*shape[4], activation='relu')(y_labels)
x = Reshape((shape[1], shape[2], shape[3],shape[4]))(x)

x = Conv3DTranspose(filters=filters,
                    kernel_size=kernel_size,
                    activation='relu',
                    strides=(2),
                    padding='same')(x)
filters //= 2
x = Conv3DTranspose(filters=filters,
                    kernel_size=kernel_size,
                    activation='relu',
                    strides=2,
                    padding='same')(x)


outputs = Conv3DTranspose(filters=1,
                          kernel_size=kernel_size,
                          activation='sigmoid',
                          padding='same',
                          name='decoder_output')(x)

# instantiate decoder model
decoder = Model( y_labels,
                outputs, 
                name='decoder')
decoder.summary()


# load decoder weights
filename = model_name + '.tf'
filepath = os.path.join(save_dir, filename)
decoder.load_weights(filepath)

# Recherche des lattices proches des 
# cibles dans le cloud initial

eng = matlab.engine.start_matlab()

MechAttainable=np.zeros([nMechDesired,5])

for i in range(nMechDesired):
    MechDesiredMatlab=matlab.double(initializer=MechDesired[i*5:i*5+5].tolist(),
                                size=[1,5],is_complex=False)  
    [yAttainableMatlab,index]=eng.ClosedDatasHdf5(fileDatabase,"/train_y",MechDesiredMatlab,nargout=2)
    MechAttainable[i,:]=np.array(yAttainableMatlab).flatten()
    axisOn=1
    output_dir_lattice_database=output_dir+"lattice_database"+str(i)+"/"
    os.makedirs(output_dir_lattice_database, exist_ok=True)
    time.sleep(1) # pause pour ralentir le code, le temps de 
   
    y_decodedMatlab=eng.verifLattice_decoded2(output_dir_lattice_database,fileDatabase,index,"/train_data",float(2),float(axisOn))
    
    print("Case ",i,":\nDesired :",MechDesired[i*5:i*5+5])
    print("Close value initial database :",MechAttainable[i,:])


layers_outputs =[layer.output for layer in decoder.layers ]

intermediate_model=Model(inputs=decoder.input,outputs=layers_outputs[4])

nFilters=layers_outputs[4].shape[4]

sizeXDecoded=input_shape[0]*input_shape[1]*input_shape[2]
arrayDataDecoded=np.zeros((nMechDesired,sizeXDecoded*nFilters))    
y_code=L2M.code_continu(MechAttainable,nMechDesired)

for i in range(nMechDesired):
    y_label=y_code[i,:].reshape(1,5)
    arrayDataDecoded[i,:] = intermediate_model.predict(y_label).reshape(1,nFilters*sizeXDecoded)

# save data in hdf5 file
dirFileDecodedHdf5=output_dir+filename_decoded

L2M.save_data(dirFileDecodedHdf5, "/MechDesired", MechDesired.flatten())
L2M.save_data(dirFileDecodedHdf5, "/MechAttainable", MechAttainable.flatten())
L2M.save_data(dirFileDecodedHdf5,"/datas",arrayDataDecoded.flatten())

for i in range(nMechDesired):   # liste des cibles mecaniques atteignables
    output_dir_lattice_NN=output_dir+"lattice_NN"+str(i)+"/"
    os.makedirs(output_dir_lattice_NN, exist_ok=True)
    y=eng.ExtractLayer(output_dir_lattice_NN,dirFileDecodedHdf5,float(i+1),'/datas',float(2),float(nFilters),nargout=1)
    for j in range(nFilters):
        dirFileSTL=output_dir_lattice_NN+str(j+1)
        fileSTL=dirFileSTL+"/"+"LatticeSTL_filters"+str(i)+str(j)+".stl"

        strCallSTL="GenerateSTL -dir "+dirFileSTL+" -height 0.05 -STL "+fileSTL +" > report.txt"
        os.system(strCallSTL)
        time.sleep(0.2) # pause pour ralentir le code, le temps d'execution de la commande precedente
