# LAGAI2_USECASE.py

# import libraries

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

filename_decoded='data24_decoded.h5'

MechDesired=np.array([15000,15000,4000,0.3,0.2,\
                      15000,7000,4000,0.3,0.2,\
                      7000,15000,4000,0.3,0.2,\
                      2000,2000,6000,0.6,0.1,\
                      4000,4000,1000,-0.4,0.1,\
                      10000,10000,10000,0.3,0.15,\
                      3000,3000,1000,0.3,0.05])
nMechDesired=int(MechDesired.shape[0]/5)

MechMinimum=np.array([500,500,200,-1,0.02])
MechMaximum=np.array([20000,20000,10000,1.0,0.2])

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

# Verify limits of mechanical entry datas
MechAttainable=MechDesired
MechAttainable.resize(nMechDesired,5)
for i in range(nMechDesired):
    for j in range(5):
        if MechDesired[i,j] < MechMinimum[j]:
            MechDesired[i,j] = MechMinimum[j]
        if MechDesired[i,j] > MechMaximum[j]:
            MechDesired[i,j] = MechMaximum[j]

# normalisation of the mechanical entry datas
sizeXDecoded=input_shape[0]*input_shape[1]*input_shape[2]
arrayDataDecoded=np.zeros((nMechDesired,sizeXDecoded))    
y_code=L2M.code_continu(MechAttainable,nMechDesired)

# decode lattice using trained NN targetting the entry mechanical datas
for i in range(nMechDesired):
    y_label=y_code[i,:].reshape(1,5)
    arrayDataDecoded[i,:] = decoder.predict(y_label).reshape(1,sizeXDecoded)

# save data in hdf5 file
dirFileDecodedHdf5=output_dir+filename_decoded

L2M.save_data(dirFileDecodedHdf5, "/MechDesired", MechDesired.flatten())
L2M.save_data(dirFileDecodedHdf5, "/MechAttainable", MechAttainable.flatten())
L2M.save_data(dirFileDecodedHdf5,"/datas",arrayDataDecoded.flatten())

# Verification of lattice decoded NN using MATLAB code
# Read of hdf5 file containing the lattice decoded by the NN
# from this datas extraction of the topology of the lattice in various csv files
# homogenization 
# obtention of a figure of the lattice
eng = matlab.engine.start_matlab()
arrayYDecoded=np.zeros((nMechDesired,5))

axisOn=1
for i in range(nMechDesired):   # liste des cibles mecaniques atteignables
    output_dir_lattice_NN=output_dir+"lattice_NN"+str(i)+"/"
    os.makedirs(output_dir_lattice_NN, exist_ok=True)
    print("value wanted :", MechAttainable[i,:])
    y_decodedMatlab=eng.verifLattice_decoded2(output_dir_lattice_NN,dirFileDecodedHdf5,float(i+1),"/datas",float(2),float(axisOn))
    arrayYDecoded[i,:]=np.array(y_decodedMatlab)[0]

    
    
L2M.save_data(dirFileDecodedHdf5,"/arrayYDecoded",arrayYDecoded.flatten())

eng.quit()