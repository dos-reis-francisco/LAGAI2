% latticeDatabase3.m

function latticeDatabase3(NombrePreCalcul, fineness, filename,train_number,...
    sx, maillage,debug)
%% données d'entrée :
% - NombrePreCalcul : nombre de points pour le calcul de la première surface 
% - fineness : finesse (ou profondeur) de calcul de la peau de fraise
% - filename : fichier de sauvegarde final des données 
% - train_number : nombre de données du fichier final
% - test_percent : poucentage de datas réservés aux tests
% - sx : seed 
% - maillage : uniquement « triangle » pour l'instant

tic

%% tout d'abord on recherche une première génération de Lattice "brouillon" 
% un nombre relativement faible de datas (10 000 ?) (deux surfaces enveloppes 
% ou une seule hypersurface ? ) 
% des cibles aléatoires
% ce sont les cibles 
if (debug=='N')
    "création d'une première série de données 'brouillons' " 
    [train_data, train_y]=CreateRandDatas(NombrePreCalcul,sx, maillage);
    save('RawDatas.mat','train_data', 'train_y');
else
    disp("récupération d'une série de données 'brouillons'");
    load('RawDatas.mat','train_data', 'train_y');
end

%% génération des deux peaux de fraise
% premier skin : [Ex, Ey, rho] 
% second skin : [Ey, Gxy, nuxy] avec une
disp("génération des deux peaux de fraise a partir des données brouillon");
TNUAGE1=train_y([1,2,5],:);
TNUAGE2=train_y([2,3,4],:);
% normalisation des données train_y
[TNUAGE1n,moyenne1,ecartType1]=NormalizeDatas(TNUAGE1);
[TNUAGE2n,moyenne2,ecartType2]=NormalizeDatas(TNUAGE2);
scaleNuage=100; % homothétie du nuage pour faciliter la visu

TNUAGE1n=scaleNuage*TNUAGE1n';
TNUAGE2n=scaleNuage*TNUAGE2n';

%TNUAGE1n=100*normalize(train_y([1 3 4],:)');

[TPOINTS1,TSEGMENTS1,TFACES1]=skin(TNUAGE1n,fineness);
drawskin(TPOINTS1,TSEGMENTS1,TFACES1,TNUAGE1n,"Ex","Ey","rho",moyenne1,ecartType1);
[TPOINTS2,TSEGMENTS2,TFACES2]=skin(TNUAGE2n,fineness);
drawskin(TPOINTS2,TSEGMENTS2,TFACES2,TNUAGE2n,"Ey","Gxy","nuxy",moyenne2,ecartType2);

%% initialisation variables pour GADIHOM
disp("initialisation des variables pour GADIHOM");
L=1;    % L : main dimension of the lattice

if maillage=="triangle" % creation matrices and variables specific to "triangle" case
    seed=sx;    
    size_data=(seed*2+4)*(seed*2+4)*12;     
    size_y=5;   %* il faut modifier la largeur de size_y pour entrer 5 
    % données variant sur deux bits chacune
    
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

% initialisation variables du code génétique 
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

total_samples = train_number;

% display a progression bar
D = parallel.pool.DataQueue;
h = waitbar(0, 'database in progress ...');
afterEach(D, @nUpdateWaitbar)

p=1;

% calculation of common variables for lattices
[nodes,Ob, Eb,delta1,delta2]=commonIhom(seed,maillage,L);
nnodes=size(nodes);
nnodes=nnodes(1);
chromosomes_0=0;
alphaBeta_0=0;

%% initialisation des variables pour la boucle principale latticeDatabase
% on calcule la surface globale de la ou des peaux de fraise à l'aide 
% des surfaces de chaque triangle
disp("initialisation des variables de la boucle principale");
surfaceGlobale=SurfaceSkin(TPOINTS1,TSEGMENTS1,TFACES1);

nfaces1=size(TFACES2,1);    % nombre de faces à traiter
nfaceTraitee=1;             % index de faces déjà traitée
TFACESTRAITEES=zeros(nfaces1,1);    % tableau des faces traitées
TFACESENCOURS=zeros(nfaces1,1);     % tableau de la liste des faces en cours de traitement

% calcul de la densité de points densite=train_number/(surface) 
 
densite=train_number/surfaceGlobale;

TFACESENCOURS(1)=1;
NumeroFaceEnCours=1;
indexLattice=1;
balayageFini=false;

%% premier appel GADIHOM pour un premier lattice 'semence' du code génétique
% [Ex, Ey, rho] 
% [Ey, Gxy, nuxy] 

% disp("extraction des données d'une première face de la seconde peau de fraise");
% [Ey_n,Gxy_n, nuxy_n]=randFirstFace(NumeroFaceEnCours,TPOINTS2,TSEGMENTS2,TFACES2);
% disp("récupération des données sur la première peau de fraise");
% [Ex_n, rhov_n]=randSecondFace(Ey_n,TPOINTS1,TSEGMENTS1,TFACES1);
% 
% [Ex,Ey,Gxy,nuxy,rhov]=orgValues(Ex_n,Ey_n,Gxy_n,nuxy_n,rhov_n,moyenne1,...
%     ecartType1,moyenne2,ecartType2,scaleNuage);
etayxy=0;
etaxxy=0;
Ex=7800;Ey=8300;Gxy=2600;nuxy=-0.3;rhov=0.2;
target=Compliance(Ex, Ey, Gxy, etayxy, etaxxy, nuxy); % compliance tensor
    
wtarget=[1 1 1 10 10 30];
disp("Recherche par GADIHOM du premier lattice 'semence'");
[bestMS4,bestChromosome,bestAlphaBeta,bestTb,chromosomes,alphaBeta]=GADIHOM3(nchromosomes,...
nkeep,rhov,nkmax,target,wtarget,mutrate,ntvalue,...
lambda,convergence,nConvergence,sx,nodes,Ob, Eb,delta1,delta2,maillage,L,"N",...
chromosomes_0,alphaBeta_0);

chromosomes_0=chromosomes;
alphaBeta_0=alphaBeta;

bestModuli=mechanic_moduli(bestMS4);

bestAlphaBeta2=(bestAlphaBeta+R)/(2*R); % normalized displacement AlphaBeta
bestAlphaBeta2=reshape(bestAlphaBeta2,nnodes,[]);
bestTb2=bestTb/MaxTb;

embeddedLattice=embedLattice(nodes,bestAlphaBeta2,bestTb2,seed,Ob, Eb,...
    delta1,delta2,L1,L2);

bestModulib=[bestModuli([1,2,3,6]) rhov];
train_y(:,indexLattice)=bestModulib;    
train_data(:,indexLattice)=embeddedLattice;

indexLattice=indexLattice+1;

send(D,1)

%% boucle principale
while (indexLattice<=train_number)
    disp("entrée dans la boucle principale");
    indexFaceEnCours=1;
    if (balayageFini==true)
        TFACESENCOURS(1)=floor(nfaces1*rand())+1;
    end
   
    while ((TFACESENCOURS(indexFaceEnCours)~=0) && (indexLattice<=train_number))
        NumeroFaceEnCours=TFACESENCOURS(indexFaceEnCours);

        SurfaceFaceEnCours=SurfaceFace(NumeroFaceEnCours,TPOINTS2,TSEGMENTS2,TFACES2);
        npoints=round(densite*SurfaceFaceEnCours);
        
        % sauvegarde des chromosomes que sur une nouvelle face 
%         chromosomes_0=chromosomes;
%         alphaBeta_0=alphaBeta;
        
        % calcul de n lattices
        disp(["Entrée dans la boucle de calcul de points sur la facette numéro :",NumeroFaceEnCours]);

        parfor i=1:npoints
            balayageFiniParfor=balayageFini;
            if ((indexLattice+i)>train_number)
                balayageFiniParfor=true;
                disp("Balayage fini dans la boucle parfor");
            end
            if (balayageFiniParfor~=true) 
                % premier skin : % [Ex, Ey, rho] 
                % second skin : [Ey, Gxy, nuxy]

                [Ey_n,Gxy_n, nuxy_n]=randFirstFace(NumeroFaceEnCours,TPOINTS2,TSEGMENTS2,TFACES2);

                [Ex_n, rhov_n]=randSecondFace(Ey_n,TPOINTS1,TSEGMENTS1,TFACES1);

                [Ex,Ey,Gxy,nuxy,rhov]=orgValues(Ex_n,Ey_n,Gxy_n,nuxy_n,rhov_n,moyenne1,...
                    ecartType1,moyenne2,ecartType2,scaleNuage);

                %% génération lattice suivant 
                target=Compliance(Ex, Ey, Gxy, etayxy, etaxxy, nuxy); % compliance tensor

                [bestMS4,bestChromosome,bestAlphaBeta,bestTb,chromosomes,alphaBeta]=...
                GADIHOM3(nchromosomes,nkeep,rhov,nkmax,target,wtarget,mutrate,ntvalue,...
                lambda,convergence,nConvergence,sx,nodes,Ob, Eb,delta1,delta2,maillage,L,"Y",...
                chromosomes_0,alphaBeta_0);

                bestModuli=mechanic_moduli(bestMS4);

                bestAlphaBeta2=(bestAlphaBeta+R)/(2*R); % normalized displacement AlphaBeta
                bestAlphaBeta2=reshape(bestAlphaBeta2,nnodes,[]);
                bestTb2=bestTb/MaxTb;

                embeddedLattice=embedLattice(nodes,bestAlphaBeta2,bestTb2,seed,...
                    Ob, Eb,delta1,delta2,L1,L2);

                bestModulib=[bestModuli([1,2,3,6]) rhov];
                train_y(:,indexLattice+i)=bestModulib;    
                train_data(:,indexLattice+i)=embeddedLattice;

                send(D,indexLattice+i)

                disp(["index Lattice traité:", indexLattice+i]);
            end
            

        end
        indexLattice=indexLattice+npoints;
        if (balayageFini~=true)
            TFACESTRAITEES(nfaceTraitee)=TFACESENCOURS(indexFaceEnCours);
            indexFaceEnCours=indexFaceEnCours+1;
            nfaceTraitee=nfaceTraitee+1;
        end
    end
    % nouvelle liste de faces contigues à celles qui sont traitées

    disp("Recherche d'une nouvelle série de faces contigües à la précédente");
    [TFACESENCOURS,balayageFini]=FacesContigues(TFACESENCOURS, TSEGMENTS2,...
        TFACES2, TFACESTRAITEES);
end

toc

%% reshape
train_data=reshape(train_data,train_number*size_data,1);
train_y=reshape(train_y,train_number*size_y,1);
disp("Sauvegarde des données dans un fichier");
%% save datas in hdf5 file
h5create(filename,'/train_data',size_data*train_number);
h5write(filename,'/train_data',train_data);
h5create(filename,'/train_y',size_y*train_number);
h5write(filename,'/train_y',train_y);

    %% function for displaying a progression bar
    function nUpdateWaitbar(~)
        waitbar(p/total_samples, h)
        p = p + 1;
    end 
end



