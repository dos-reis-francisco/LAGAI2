# ReadMe for Github repository of LAGAI Project
Note : this repository is for reviewer eyes only of preprint article "Deep learning, deconvolutional neural network inverse design of strut-based lattice metamaterials"

- [ReadMe for Github repository of LAGAI Project](#readme-for-github-repository-of-lagai-project)
  - [Introduction](#introduction)
  - [Preliminary informations](#preliminary-informations)
    - [hardware configuration used by author](#hardware-configuration-used-by-author)
    - [Software configuration used by author](#software-configuration-used-by-author)
  - [1. Database generation part](#1-database-generation-part)
    - [Summary](#summary)
    - [HOW TO USE](#how-to-use)
  - [2. Training NN part](#2-training-nn-part)
    - [Summary](#summary-1)
    - [HOW TO USE](#how-to-use-1)
  - [3. USE of trained NN Part](#3-use-of-trained-nn-part)
    - [Summary](#summary-2)
    - [HOW TO USE](#how-to-use-2)


## Introduction
The code is divided into three parts :
1. The database generation part
2. The training NN part
3. The NN use part

These parts are detailed below. The reader who want to try only the trained DCNN can jump into part three.
Before that, in order to execute the software, user must verify if compatible software is installed. 

## Preliminary informations
### hardware configuration used by author
The code was executed on a PC :
* AMD Ryzen 7 2700 (8 cores / 3.1 GHz)
* 32 Go RAM
* B450 Mainboard 
* RTX 4060 GPU
  
### Software configuration used by author
The code was written essentially in two langage : MATLAB and Python.

* PC computer with :
  * windows 11
  * python 3.9
  * Visual studio code
   * Matlab 2021b with matlab engine python library installed (allow call to Matlab engine from python)
  * tensorflow 2.9
  * Keras 
  * cudnn 8.1
  * cuda toolkit 11.2

## 1. Database generation part
### Summary
This part is created using MATLAB. 
In summary :
1. A random target of mechanical values is generated :[Ex, Ey, Gxy,nuyx,rho]
2. The algorithm search for the lattice with mechanical homogenized values closest to target
   * it use for search, a genetic algorithm  combined with homogenization
3. Once lattice is found it's embedded in a 3D Matrix
4. loop to 1. until total samples are generated
5. store all 3D matrix samples in a hdf5 file

(see https://doi.org/10.1016/j.ijsolstr.2022.111702 for detailed explanations of genetic algorithm, https://doi.org/10.1016/j.softx.2020.100446 for lattice homogenization, preprint submitted explain the embedding)

### HOW TO USE
execute in MATLAB
~~~
CreateDatas(filename,number,seed,topology)
~~~
with :
- filename : name of the hdf5 file database to be created
- number : number of sample of the database
- seed : value of number of subdivision of the basic cell (2 is advised)
- topology : "triangle" is the only topology implemented yet

Example :
~~~
CreateDatas("database24.h5",100000,2,"triangle")
~~~
Create a database of 100000 samples stored in the file "database24.h5"
(Please note that for this calculation it takes about 240h on my computer. The reader who just want to try the DCNN code can jump into part three "use of DCNN code")

## 2. Training NN part 
### Summary 
In this part one train the DCNN with the previous database. 
Once it's trained the weights of the decoder are stored in a special directory.

### HOW TO USE
* firstly : edit the parameters in the beginnig of the file **_LAGAI2_TRAIN.py_**,  at least :
  * filename_database="database24.h5"
  * number_element=100000
  * number_train_samples=95000
  * number_test_samples=5000

according to the filename and number of samples.
Then execute the python file  
~~~
LAGAI2_TRAIN.py
~~~
the python code will store the trained weights in a directory actually called "decoder_weights".
See the preprint for more explanations on how the DCNN is constituted. 
## 3. USE of trained NN Part
Note : the DCNN code is written in python, but the disembedding of 3D Matrix obtained requires call to Matlab engine from python. This import library must be installed before.

### Summary 
* firstly edit the parameters in the beginning of **_LAGAI2_USECASE.py_** file, at least :
  * MechDesired : this is a numpy array containing the targets one want to experiment
  * filedatabase : name of the initial database
  * save_dir : name of the directory containing the weights of the trained NN
* To avoid physically impossible material target (example Elastic modulus too high vs density), before call of decoder NN, the module of the targets are restricted to the hypervolume define by the initial database. 
* DCNN is called with restricted values of target to generate 3D Matrix containing the lattice. 
* each 3D Matrix generated is disembedded into a lattice. 
* Datas of the lattices generated are saved into output directy, in csv files  
* additionnaly closest lattice from the initial database is extracted.
* homogenized mechanical values are calculated

### HOW TO USE
Just call with python 
~~~
LAGAI2_USECASE.py
~~~

