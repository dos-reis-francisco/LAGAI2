# LAGAI2_.py
# Part training model for LAGAI2

# import libraries

import time
import tensorflow as tf
import tensorflow.keras as keras

from tensorflow.keras.layers import Dense, Input
from tensorflow.keras.layers import Reshape, Conv3DTranspose
from tensorflow.keras.models import Model
from tensorflow.keras.losses import mse
from tensorflow.keras.utils import plot_model
from tensorflow.keras import backend as K
import numpy as np
import os
import LAGAI2MODULES as L2M


#################################### PARAMETERS ##############################
# database parameters
filename_database="database24.h5"
number_element=100000

number_train_samples=95000
number_test_samples=5000

# network parameters
# input_shape = (raws, columns, depth, layers) 

batch_size = 128
kernel_size = 3
filters = 16
filters_initial=64
latent_dim = 2
epochs = 30

input_shape =(8,8,12,1)
label_shape=(5,)

len_train=input_shape
len_y=5   # a reformatter en label_shape

model_name = "LAGAI2_decoder"
save_dir = "decoder_weights"

####################### CODE ########################################
print(tf.__version__)
print(keras.__version__)
print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))

# load data

[x_train, y_train, x_test, y_test]=L2M.load_data(filename_database,
    number_train_samples,number_test_samples,input_shape,label_shape)
new_shape_train=(number_train_samples,)+input_shape

x_train=x_train.reshape(new_shape_train)  
y_train=y_train.reshape(number_train_samples,len_y)

x_test=x_test.reshape((number_test_samples,)+input_shape)
y_test=y_test.reshape(number_test_samples,len_y)

y_train=L2M.code_continu(y_train,number_train_samples)
y_test=L2M.code_continu(y_test,number_test_samples)

# The Generator by deconvolution is constituted of two parts : the decoder and the Training model. The training model is composed 
# of the decoder and add a loss function as "discriminator".

# build decoder model

inputs = Input(shape=input_shape, name='decoder_input')
y_labels = Input(shape=label_shape, name='mechanical_values')

shape=np.array([0,2,2,3,filters_initial]) # shape of the first layer of the decoder (to be modified)
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
                    strides=2,
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
plot_model(decoder,
           to_file='LAGAI2_decoder.png', 
           show_shapes=True)

# build the training model
outputs_discriminator = [inputs,decoder(y_labels)]
LAGAI2 = Model([inputs, y_labels], outputs_discriminator, name='LAGAI2')

print("LAGAI2: training model")


# add loss fonction
reconstruction_loss = mse(K.flatten(inputs), K.flatten(outputs))
reconstruction_loss *= input_shape[0] * input_shape[1]*input_shape[2]
LAGAI2.add_loss(reconstruction_loss)

LAGAI2.compile(optimizer='rmsprop')
LAGAI2.summary()
plot_model(LAGAI2, to_file='LAGAI2_NN.png', show_shapes=True)

if not os.path.isdir(save_dir):
    os.makedirs(save_dir)



# train the model
LAGAI2.fit([x_train, y_train],
            epochs=epochs,
            batch_size=batch_size,
            validation_data=([x_test, y_test], None))

# save decoder weights
filename = model_name + '.tf'
filepath = os.path.join(save_dir, filename)
decoder.save_weights(filepath)
