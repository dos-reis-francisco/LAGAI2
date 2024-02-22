
function [train_data,train_y]=CreateRandDatas(train_number,sx, maillage)
% – train_data : variable data a sauvegarder dans un fichier .hdf5
% – train_y : variable y a sauvegarder dans un fichier .hdf5
% – train_number : nombre de lattices à créer
% – sx : seed number 
% – maillage : « triangle » pour l'instant

L=1;    % L : main dimension of the lattice

%% beginning code
tic

%% creation matrices and variables specific to "triangle" case
if maillage=="triangle"
    seed=sx;    
    size_data=(seed*2+4)*(seed*2+4)*12;     
    size_y=5;   %* il faut modifier la largeur de size_y pour entrer 5 données variant sur deux bits chacune
    
    train_data=zeros(size_data,train_number);
    train_y=zeros(size_y,train_number);                    
    
    % initialisation of variables case of "triangle"
    R=L/(4*sx);     % max value of alphaBeta
    L1=L;
    L2=L;
    longueurPoutres=2*L+2*L*sqrt(2);
    VolumeMatiere=0.2*L*L;
    MaxTb=2*VolumeMatiere/longueurPoutres;
end

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
% sx=2;% number of beams on x side
% maillage="triangle"; % type of mesh : "triangle" or "hexagon"
% L=10; %basis length of lattice directors 
% Thk=1; % general thickness of the lattice, for 3D printing use essentially
% BeamType="beams"; % type of beams : "beams"== solid beams, "tubes" == tubes beams 

% – on peut proposer une valeur fixe pour Ex : 3000
TEx=[20000,15000,10000,500];
% % ∗ une variation E_{y}\in\{3000,2250,1500,750,100\}
TEy=[20000,15000,10000,500];
% % ∗ une variation G_{xy}\in\{1500,2000,3000,750,100\}
TGxy=[8000,6000,4000, 200];
% % ∗ une variation \eta_{yxy}\in\{0,0.4,0.8,-0.4,-0.8\}
Tetayxy=[0,0.4,0.8,-0.4,-0.8];
% % ∗ une variation \eta_{xxy}\in\{0,0.4,0.8,-0.4,-0.8\}
Tetaxxy=[0,0.4,0.8,-0.4,-0.8];
% % ∗ une variation \nu_{yx}\in\{0,0.4,0.8,-0.4,-0.8\}
Tnuyx=[-1.0,-0.5,+0.5,1.0];

Trhov=[0.2,0.1,0.05,0.02];

% tableaux pour wtarget
TwEx=[1 1 1 1];
TwEy=[1 1 1 1];
TwGxy=[1 1 1 1];
Twetayxy=[1 1 100 100 100];
Twetaxxy=[1 1 100 100 100];
Twnuyx=[100 100 1 1 ];

total_samples = train_number;

%% display a progression bar
D = parallel.pool.DataQueue;
h = waitbar(0, 'database in progress ...');
afterEach(D, @nUpdateWaitbar)
p=1;

% calculation of common variables for lattices
[nodes,Ob, Eb,delta1,delta2]=commonIhom(seed,maillage,L);
nnodes=size(nodes);
nnodes=nnodes(1);

%% parallel loop for calculation database
parfor i=1:train_number
    % update baselattice
    rhov=0.2*rand()+0.02;
    Ex=210000*rhov*rand();
    Ey=210000*rhov*rand();
    Gxy=80000*rhov*rand();

    etayxy=0;
    etaxxy=0;
    nuyx=2*rand()-1;    
    
    target=Compliance(Ex, Ey, Gxy, etayxy, etaxxy, nuyx); % compliance tensor
    
    wtarget=[1 1 1 10 10 30];
    chromosomes_0=0;
    alphaBeta_0=0;
    [bestMS4,bestChromosome,bestAlphaBeta,bestTb,chromosomes,alphaBeta]=GADIHOM3(nchromosomes,...
    nkeep,rhov,nkmax,target,wtarget,mutrate,ntvalue,...
    lambda,convergence,nConvergence,sx,nodes,Ob, Eb,delta1,delta2,maillage,L,'N',...
    chromosomes_0,alphaBeta_0);

%     cible=[Ex, Ey, Gxy, etayxy, etaxxy, nuyx];
%     obtenu=mechanic_moduli(bbMS4);
%     mse2(bbMS4,target)
    bestModuli=mechanic_moduli(bestMS4);
    
    bestAlphaBeta2=(bestAlphaBeta+R)/(2*R); % normalized displacement AlphaBeta
    bestAlphaBeta2=reshape(bestAlphaBeta2,nnodes,[]);
    %* il faudrait à la place du calcul précédent, une estimation
    %normalisée basée sur la valeur vraie maximum  que pourrait prendre Tb
    bestTb2=bestTb/MaxTb;
    
    embeddedLattice=embedLattice(nodes,bestAlphaBeta2,bestTb2,seed,Ob, Eb,delta1,delta2,L1,L2);
    
%     if (i==1)
%         print_embedded('matrix1.txt',seed,embeddedLattice);
%     end
    % save y result
    % bestMS4b=[bestMS4([1,2,6]) rhov];  %*  le tout en codage binaire
    bestModulib=[bestModuli([1,2,3,6]) rhov];
    train_y(:,i)=bestModulib;    %* peut-être que cela peut être fait après coup lors de l'enregistrement du lattice
    % save data result
    train_data(:,i)=embeddedLattice;
    
    send(D,i)
end


%% function for displaying a progression bar
function nUpdateWaitbar(~)
    waitbar(p/total_samples, h)
    p = p + 1;
end

end