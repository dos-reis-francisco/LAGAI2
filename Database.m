%Database.m 
% generate a database to test graph neural network 
% 19.08.2022
% Dos Reis Francisco

function Database(filename,rhov,train_number,validation_number, test_number, sx, L, maillage)
%% inputs
% filename : name of the hdf5 to output
% rhov : relative density of the lattice
% train_number : number of sample for training
% validation_number : number of sample for validation
% test_number : number of sample for test
% sx : number of divisions of the lattice for first dimension 
% L : main dimension of the lattice
% maillage : type of mesh, must be "triangle" or "hexagon"

ntvalue=1000;   % maximum value for beam width t in range [tmin..ntvalue]
tmin=100;

E=2900; % nylon elasticity modulus
Y1=[1 0];Y2=[0 1]; % definition of lattice directors assuming rectangular base cell

%% Evaluation of L1, L2 and R
if maillage=="triangle"
    seed=sx;
    L1=L ; L2=L; %length of lattice directors 
    R=L/(4*sx);
elseif maillage=="hexagon"
    L1=L;
    l=L1/(sqrt(3)*sx);
    sy=floor(sx/sqrt(3));
    if (sy<1) 
        sy=1;
    end
    L2=3*l*sy;
    R=L1/(2*sqrt(3)*sx);
end

%% meshing 
if maillage=="triangle"
    [nbeams,nnodes,nodes,Ob,Eb,delta1,delta2]=MeshTriangle(seed,L1,L2);   
elseif maillage=="hexagon"
    [nbeams,nnodes,nodes,Ob,Eb,delta1,delta2]=MeshHexa(sx,sy,l);  
end  
Elast=E*ones(nbeams,1);

%% creation matrices train, validation and test
if maillage=="triangle"
    size_data=(seed*2+3)*(seed*2+3)*11;
    size_y=6;
    
    train_data=zeros(train_number*size_data,1);
    train_y=zeros(train_number*size_y,1);
    validation_data=zeros(validation_number*size_data,1);
    validation_y=zeros(validation_number*size_y,1);
    test_data=zeros(test_number*size_data,1);
    test_y=zeros(test_number*size_y,1);    
end

%% loops calculation database
for i=1:train_number
    chromosomes=(ntvalue-tmin)*rand(nbeams,1)+tmin ;
    %
    r=R*rand(nnodes,1);
    theta=2*3.1415*rand(nnodes,1);
    alphaBeta=[r.*cos(theta) r.*sin(theta)];
    nodes2=nodes+alphaBeta;
    %
    ct=EvaluateCt(chromosomes,nodes2,nbeams,Ob,Eb,delta1,...                    
    delta2,L1,L2,rhov,alphaBeta);

    Tb=ct*chromosomes;
    Tb2=chromosomes/1000;   % j'utilise des valeurs normalisées pour le 
                            % stockage de Tb
    base_y=(i-1)*size_y+1;
    [MExtracted,train_y(base_y:(base_y+size_y-1))]=homogenization(Tb,L1,L2,Y1,Y2,nbeams,...               
    nnodes,nodes2,Ob,Eb,delta1,delta2,Elast);
    
    base_data=(i-1)*size_data+1;
    train_data(base_data:(base_data+size_data-1))=embedLattice(nodes,nodes2,Tb2,seed,Ob, Eb,delta1,delta2,L1,L2);
end

for i=1:validation_number
    chromosomes=(ntvalue-tmin)*rand(nbeams,1)+tmin ;
    %
    r=R*rand(nnodes,1);
    theta=2*3.1415*rand(nnodes,1);
    alphaBeta=[r.*cos(theta) r.*sin(theta)];
    nodes2=nodes+alphaBeta;
    %
    ct=EvaluateCt(chromosomes,nodes2,nbeams,Ob,Eb,delta1,...                    
    delta2,L1,L2,rhov,alphaBeta);

    Tb=ct*chromosomes;
    Tb2=chromosomes/1000;   % j'utilise des valeurs normalisées pour le 
                            % stockage de Tb
    base_y=(i-1)*size_y+1;
    [MExtracted,validation_y(base_y:(base_y+size_y-1))]=homogenization(Tb,L1,L2,Y1,Y2,nbeams,...               
    nnodes,nodes2,Ob,Eb,delta1,delta2,Elast);
    
    base_data=(i-1)*size_data+1;
    validation_data(base_data:(base_data+size_data-1))=embedLattice(nodes,nodes2,Tb2,seed,Ob, Eb,delta1,delta2,L1,L2);
end

for i=1:test_number
    chromosomes=(ntvalue-tmin)*rand(nbeams,1)+tmin ;
    %
    r=R*rand(nnodes,1);
    theta=2*3.1415*rand(nnodes,1);
    alphaBeta=[r.*cos(theta) r.*sin(theta)];
    nodes2=nodes+alphaBeta;
    %
    ct=EvaluateCt(chromosomes,nodes2,nbeams,Ob,Eb,delta1,...                    
    delta2,L1,L2,rhov,alphaBeta);

    Tb=ct*chromosomes;
    Tb2=chromosomes/1000;   % j'utilise des valeurs normalisées pour le 
                            % stockage de Tb
    base_y=(i-1)*size_y+1;
    [MExtracted,test_y(base_y:(base_y+size_y-1))]=homogenization(Tb,L1,L2,Y1,Y2,nbeams,...               
    nnodes,nodes2,Ob,Eb,delta1,delta2,Elast);
    
    base_data=(i-1)*size_data+1;
    test_data(base_data:(base_data+size_data-1))=embedLattice(nodes,nodes2,Tb2,seed,Ob, Eb,delta1,delta2,L1,L2);
end

%% save datas in hdf5 file
h5create(filename,'/train_data',size_data*train_number);
h5write(filename,'/train_data',train_data);
h5create(filename,'/train_y',size_y*train_number);
h5write(filename,'/train_y',train_y);

h5create(filename,'/validation_data',size_data*validation_number);
h5write(filename,'/validation_data',validation_data);
h5create(filename,'/validation_y',size_y*validation_number);
h5write(filename,'/validation_y',validation_y);

h5create(filename,'/test_data',size_data*test_number);
h5write(filename,'/test_data',test_data);
h5create(filename,'/test_y',size_y*test_number);
h5write(filename,'/test_y',test_y);