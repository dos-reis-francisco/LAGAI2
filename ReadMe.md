# ReadMe for Github repository of LAGAI Project
Note : this repository is for reviewer eyes only of preprint article "Deep learning, deconvolutional neural network inverse design of strut-based lattice metamaterials"

- [ReadMe for Github repository of LAGAI Project](#readme-for-github-repository-of-lagai-project)
  - [Introduction](#introduction)
  - [Preliminary informations](#preliminary-informations)
    - [hardware configuration used by author](#hardware-configuration-used-by-author)
    - [Software configuration used by author](#software-configuration-used-by-author)
  - [DCNN USE](#dcnn-use)
    - [Preliminary remarks](#preliminary-remarks)
    - [Summary](#summary)
    - [HOW TO USE](#how-to-use)


## Introduction
Before use, in order to execute the software, user must verify if compatible software is installed. 

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

## DCNN USE 
### Preliminary remarks
1. the DCNN code is written in python, but the disembedding of 3D Matrix obtained requires call to Matlab engine from python. This Matlab engine import library must be installed before use.
2. The directory "decoder_weights" must be filled before use of this part. One can use the furnished weights (from author previous trained NN)

### Summary 
* firstly edit the parameters in the beginning of **_LAGAI2_USECASE.py_** file, at least :
  * MechDesired : this is a numpy array containing the targets one want to experiment
  * save_dir : name of the directory containing the weights of the trained NN
* or you can used proposed datas
* To limit physically impossible material target, example Elastic modulus too high, before call of decoder NN, the module of the targets are restricted to mini,maxi values. However, the user's attention is drawn to the fact that not all combinations are physically possible. 
* DCNN is called with restricted values of target to generate 3D Matrix containing the lattice. 
* each 3D Matrix generated is disembedded 
* Datas of the lattices generated are saved into output directy, in csv files format
* svg graphic output is created from NN generated lattice and initial database 
* homogenized mechanical values of the generated lattice are calculated


### HOW TO USE
Just call with python 
~~~
LAGAI2_USECASE.py
~~~

