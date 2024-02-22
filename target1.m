%target1.m 
% for GADIHOM (2022)
               
nchromosomes=128; % number of chromosomes (must be 4 factor)
nkeep=64;   % number of keeped chromosomes
rhov=0.1; % homogenized volumic density target                                                       
nkmax=1000; % number iterations max
% Material properties target
Ex=3000; Ey=3000; Gxy=1200; etayxy=0.0; etaxxy=0.0; nuyx=0.3;
mechTarget=[Ex, Ey, Gxy, etayxy, etaxxy, nuyx];
target=Compliance(Ex, Ey, Gxy, etayxy, etaxxy, nuyx); % compliance tensor
wtarget=[1 1 1 1 1 1]; %weight vector
mutrate=0.1;  % mutation rate
ntvalue=1000;   % maximum value for beam width t in range [tmin..ntvalue]
lambda=1;   % vector of weights  
convergence=0.01;
nConvergence=30;
sx=2;% number of beams on x side
maillage="triangle"; % type of mesh : "triangle" or "hexagon"
L=10; %basis length of lattice directors 

GADIHOM(nchromosomes,nkeep,rhov,sx,nkmax,target,wtarget,mutrate,ntvalue,...
lambda,convergence,nConvergence,maillage,L,mechTarget);