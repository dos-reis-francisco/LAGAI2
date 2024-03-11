# ReadMe for the Github repository of the SLAGAI model
Note : This repository relates to the preprint of the article "Deep learning, deconvolutional neural network inverse design of strut-based lattice metamaterials".

- [ReadMe for the Github repository of SLAGAI model](#readme-for-github-repository-of-slagai-model)
  - [Introduction](#introduction)
  - [Preliminary informations](#preliminary-informations)
    - [hardware configuration used by author](#hardware-configuration-used-by-author)
    - [Software configuration used by author](#software-configuration-used-by-author)
  - [DCNN use](#dcnn-use)
    - [Preliminary remarks](#preliminary-remarks)
    - [Summary](#summary)
    - [How to use](#how-to-use)
  - [DCNN results](#dcnn-results)

## Introduction
The De-Convolutiona Neural Network (DCNN) model computes strut-based lattice patterns that optimally fit a set of mechanical targets, namely the set of normal moduli (Ex, Ey), the shear modulus (Gxy), Poisson's ratio and relative density of the metamaterial. Before the use of the DCNN model, compatible software modules have to be installed. A summary of the softare requirements, program execution and associated results is provided below.  

## Preliminary information
### Hardware configuration used for the execution of the DCNN
The code was executed on a PC:
* AMD Ryzen 7 2700 (8 cores / 3.1 GHz)
* 32 GBy RAM
* B450 Mainboard 
* RTX 4060 GPU
  
### Software configuration 
The DCNN code combines software modules written in Python and Matlab. 

* For the execution, the installation of the following software parts is required:
  * Python 3.9
  * Matlab 2021b with matlab engine python library 
  * Tensorflow 2.9
  * Cudnn 8.1
  * Cuda toolkit 11.2

## DCNN use 
### Preliminary remarks
1. The DCNN code is written in python, but the disembedding of the 3D Matrix obtained requires the use of a set of Matlab routines (Matlab engine) which are directly called from the main python code. The relevant Matlab engine library must be therefore installed before use.
2. The directory "decoder_weights" must be filled before the use of this part. The directory is filled with weights obtained from the network training.

### Summary 
* The target mechanical parameters are defined in the initial part of the **_LAGAI2_USECASE.py_** routine, as follows:
  * MechDesired :The numpy array containing the mechanical targets in the following order: Ex, Ey, Gxy, nu, rho
  * save_dir : The name of the directory containing the weights of the trained NN.
* The target mechanical properties provided as default values in MechDesired assume steel with a 210000 MPa elastic modulus.
* To limit physically impossible mechanical targets, e.g. exceptionally high elastic moduli requests, mechanical bounds on the upper and lower requests per parameters are set (MechMinimum, MechMaximum). It has to be noted that mechanical requests have to be further rationalized with respect to the underlying feasible mechanical space, as detailed in the article. 
* The DCNN model generates the 3D Matrix containing the lattice topology for the requested mechanical performance. 
* The 3D Matrix generated is disembedded employing the Matlab engine routines. 
* The generated lattice data are saved into an output directy, its content detailed below.

The module is self-contained and does not consider the initial database for its execution. The initial database, the code for its development and for the training of the DCNN model can be found in https://data.mendeley.com/preview/vb25pch8mp?a=b9d827d5-f1ab-4ead-9edc-ee09eb9820d7. 

### How to use
The main Python script to be called is the following:
~~~
LAGAI2_USECASE.py
~~~

## DCNN results
An output folder is created, with a series of subfolders that are equal to the number of mechanical performance combinations requested in LAGAI2_USECASE.py (parameter:MechDesired). In the output subfolders, the nodal displacements of the initially triangulated lattice (nodes.csv) following the convention of Figure 5 of the associated manuscript, the element thickness distribution (Tb.csv) and the set of effective mechanical properties (decoded_results.txt) of the reconstructed lattice pattern, along with a svg graphical output file are provided.
