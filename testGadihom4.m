sx=2;
seed=sx;    
L=1;
maillage="triangle";

% initialisation of variables case of "triangle"
R=L/(4*sx);     % max value of alphaBeta
L1=L;
L2=L;

    
%% initialisation variables 
nchromosomes=64; % number of chromosomes (must be 4 factor)
nkeep=32;   % number of keeped chromosomes
% rhov=0.1; % homogenized volumic density target                                                       
nkmax=1000; % number iterations max
% Material properties target

mutrate=0.15;  % mutation rate
ntvalue=1000;   % maximum value for beam width t in range [tmin..ntvalue]
lambda=1;   % vector of weights  
convergence=0.005;
nConvergence=100;

[nodes,Ob, Eb,delta1,delta2]=commonIhom(seed,maillage,L);
nnodes=size(nodes);
nnodes=nnodes(1);

Ex=10000;
Ey=10000;
Gxy=5000;
rhov=0.1;
 
etayxy=0.0;
etaxxy=0.0;
nuyx=0.3;

target=Compliance(Ex, Ey, Gxy, etayxy, etaxxy, nuyx); % compliance tensor
wtarget=[1 1 1 10 10 30];

load('GADatas.mat','chromosomes','alphaBeta');

[bestMS4,bestChromosome,bestAlphaBeta,bestTb,chromosomes,alphaBeta]=GADIHOM3(nchromosomes,nkeep,...
rhov,nkmax,target,wtarget,mutrate,ntvalue,...
lambda,convergence,nConvergence,sx,nodes,Ob, Eb,delta1,delta2,maillage,L,"Y",...
chromosomes,alphaBeta);
mechanic_moduli(bestMS4)