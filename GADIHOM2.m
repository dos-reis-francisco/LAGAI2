%% GADIHOM2.m
% compute the inverse homogenization of a lattice
% Dos Reis F.
% 2021.02.13
% modified 2022.04.25
% modified 2022.08.24
% modified 2022.08.26

function [bestMS4,bestChromosome,bestAlphaBeta,bestTb]=GADIHOM2(nchromosomes,nkeep,rhov,nkmax,target,wtarget,mutrate,ntvalue,...
lambda,convergence,nConvergence,sx,nodes,Ob, Eb,delta1,delta2,maillage,L)
%% inputs 
% nchromosomes : number of chromosomes to be calculted in the same time
% nkeep : number of keeped chromosomes
% rohv : relative density considered
% nkmax : iterations maximum
% target : compliance tensor target
% wtarget : vector of weights for target tensor
% mutrate : mutation rate
% ntvalue : number of value for width usually range [0 .. 1000]
% lambda : weight for relative ponderation of maximum values for tensor
% obtain
% convergence : value to consider the search has converged
% nconvergence : how many loops beneath convergence for stopping
% sx : seed base for meshing
% nodes : nodes coordinates
% Ob : origin node number
% Eb :ending node number
% delta1 : index shifting 1
% delta2 : index shifting 2
% maillage : must be "triangle" or "hexagon"
% L : base lattice dimension

%% outputs
% bbMS4 : best MS4 values <==> true compliance tensor obtained vs initial
% target
% bbChromosome : best chromosome (list of widths in the range [tmin .. 1000]
% bbAlphaBeta : best AlphaBeta values (displacements of the nodes)

%% beginning of the code
Y1=[1 0];Y2=[0 1]; % definition of lattice directors assuming rectangular base cell
tmin=1;  % minimum value considered for beam's width
tbmin=10; % minimum value width in range [tmin..ntvalue] for simplification of the lattice
Tbmin=0; % minimum value width in true value
Es=210000;  % Elasticity modulus

%% init variables
meanc=zeros(1,nkmax);   % mean cost
minc=zeros(1,nkmax); % min cost
ct=zeros(1,nchromosomes);   % density constant function
MExtracted=zeros(nchromosomes,10);
MS4=zeros(nchromosomes,6);
cost=zeros(1,nchromosomes);
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
    %R=L1/(2*sqrt(3)*sx);
    R=L1/(sqrt(3)*sx);    % modif temporaire 16.05
end
   
nbeams = size(Ob);
nbeams=nbeams(1);
nnodes = size(nodes(:,1));
nnodes =nnodes(1);

Elast=Es*ones(1,nbeams) ; % matrix size (1 x nbeams)Value of elastic modulus
chromosomes=zeros(nchromosomes,nbeams);
Tb=zeros(nchromosomes,nbeams);
bestChromosome=zeros(1,nbeams);
bestAlphaBeta=zeros(1,nnodes,2);
bestMS4=zeros(1,6);
bestMech=zeros(1,10);


%% init variables
cgene=0;    % counter of total gene created, for chromosomes beams 
            % reset when > 1/mutrate         
cgene2=0; % counter of total gene created, for chromosomes nodes
            % reset when > 1/mutrate    
nlowIter=0; % loop counter for convergence
meanc=zeros(1,nkmax);   % mean cost
minc=zeros(1,nkmax); % min cost
%% first generation
% initial chromosomes beams
    
chromosomes=(ntvalue-tmin)*rand(nchromosomes,nbeams)+tmin ;% matrix size           
                                % (nchromosomes x nbeams) of width
% initial chromosomes nodes : one set of [alpha,beta] per chromosomes
% beams
alphaBeta=zeros(nnodes,2,nchromosomes);
for i=1:nchromosomes
    r=R*rand(nnodes,1);
    theta=2*3.1415*rand(nnodes,1);
    alphaBeta(:,:,i)=[r.*cos(theta) r.*sin(theta)];
    % alphaBeta=(1.0*rand(nnodes,2,nchromosomes)-0.5); % in the range [-0.5,0.5]              
end
% update ct : scale density value
ct=EvaluateCt(nchromosomes,chromosomes,nodes,nbeams,Ob,Eb,delta1,...                    
    delta2,L1,L2,rhov,alphaBeta);

% Homogenization & cost for each chromosome (first generation)
for i=1:nchromosomes
    % evaluate width beams
    Tb(i,:)=ct(1,i)*chromosomes(i,:);

%         % remove thin beams
%         Tbmin=ct(1,i)*tbmin;
%         [nbeams2,nnodes2,nodes2,Tb2,Ob2,Eb2,delta12,delta22]=...                 
%         RemoveBeams(Tbmin,Tb(i,:),nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,...
%         alphaBeta,i);
    nodes2=nodes+alphaBeta(:,:,i);
    % homogenize the lattice without thin beams
    [MExtracted(i,:),MS4(i,:)]=homogenization(Tb(i,:),L1,L2,Y1,Y2,nbeams,...               
    nnodes,nodes2,Ob,Eb,delta1,delta2,Elast);
    A=target;B=MS4(i,:);
    cost(1,i)=fcost(A,B,wtarget,lambda);
end

% Sort
[cost,ind]=sort(cost,'ascend'); % sort of chromosomes ascending
chromosomes=chromosomes(ind,:);  % update chromosomes beams from the best         
                                % to the worst
alphaBeta=alphaBeta(:,:,ind); % update chromosomes nodes from best to worst             
meanc(1,1)=mean(cost);    % values first generation
minc(1,1)=min(cost);
% function of probability distribution
M=ceil((nchromosomes-nkeep)/2); % number of matings
prob=flipud([1:nkeep]'/sum([1:nkeep])); % weights chromosomes
odds=[0 cumsum(prob(1:nkeep))']; % probability distribution function 

%% loop
for iga=2:nkmax   % generation counter
    % Selection 
    pick1=rand(1,M); % mate #1 (vector of length M with random #s 
                     % between 0 and 1)
    pick2=rand(1,M); % mate #2

    % ma and pa contain the indices of the chromosomes that will mate
    % Choosing integer k with probability p(k)
    ma=zeros(1,M);
    pa=zeros(1,M);
    for ic=1:M
        for id=2:nkeep+1
            if pick1(ic)<=odds(id) && pick1(ic)>odds(id-1)
                ma(ic)=id-1;
            end
            if pick2(ic)<=odds(id) && pick2(ic)>odds(id-1)
                pa(ic)=id-1;
            end
        end
        if (ma(ic)==pa(ic)) 
            ma(ic)=ma(ic)+1;
        end
    end

    xp=ceil(rand(1,M)*(nbeams-1)); % crossover point mate in chromosomes beams
    yp=ceil(rand(1,M)*(nnodes-1)); % crossover point mate in chromosomes nodes alphaBeta
    for i=1:M/2
        % mating chromosomes beams
        chromosomes(nkeep+i*2-1,:)=[chromosomes(ma(i),1:xp(i)) ...          
            chromosomes(pa(i),xp(i)+1:nbeams)];
        chromosomes(nkeep+i*2,:)=[chromosomes(pa(i),1:xp(i)) ...             
            chromosomes(ma(i),xp(i)+1:nbeams)];
        % mating the same number of chromosomes nodes
        alphaBeta(:,:,nkeep+i*2-1)=[ alphaBeta(1:yp(i),:,ma(i)); ...                    
            alphaBeta(yp(i)+1:nnodes,:,pa(i))];
        alphaBeta(:,:,nkeep+i*2)=[ alphaBeta(1:yp(i),:,pa(i)); ...                      
            alphaBeta(yp(i)+1:nnodes,:,ma(i))];

    end 
    
    % Mutation 
    cgene=cgene+(nchromosomes-nkeep)*nbeams;  % j'opère une mutation      
                            % uniquement sur les nouveaux chromosomes
    cgene2=cgene2+(nchromosomes-nkeep)*nnodes;
    nmut=floor(cgene*mutrate);                                           
    nmut2=floor(cgene2*mutrate);
    % mutation genes in chromosomes beams
    if nmut>1                                                          
        cgene=0;
        for i=1:nmut
            mutc=ceil((nchromosomes-nkeep)*rand());    % 
            mutg=ceil(nbeams*rand());
            chromosomes(nkeep+mutc,mutg)=ntvalue*rand();
        end
    end
    % mutation genes in chromosomes nodes
    if nmut2>1                                                          
        cgene2=0;
        for i=1:nmut2
            mutc=ceil((nchromosomes-nkeep)*rand());    % 
            mutg=ceil(nnodes*rand());
            r=R*rand(1,1);
            theta=2*3.1415*rand(1,1);
            alphaBeta(mutg,:,nkeep+mutc)=[r*cos(theta) r*sin(theta)];
            % alphaBeta(mutg,:,nkeep+mutc)=(1.0*rand(1,2)-0.5);                           
        end
    end

    % update ct
    ct=EvaluateCt(nchromosomes,chromosomes,nodes,nbeams,Ob,Eb,...                       
        delta1,delta2,L1,L2,rhov,alphaBeta);

    % Homogenization & cost for each chromosome (loop)
    for i=1:nchromosomes
        Tb(i,:)=ct(1,i)*chromosomes(i,:);
%             % remove beams
%             Tbmin=ct(1,i)*tbmin;
%             [nbeams2,nnodes2,nodes2,Tb2,Ob2,Eb2,delta12,delta22]=...             
%             RemoveBeams(Tbmin,Tb(i,:),nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,...
%             alphaBeta,i);
        %homogenization
        nodes2=nodes+alphaBeta(:,:,i);
        [MExtracted(i,:),MS4(i,:)]=homogenization(Tb(i,:),L1,L2,Y1,Y2,...                   
        nbeams,nnodes,nodes2,Ob,Eb,delta1,delta2,Elast);
        A=target;B=MS4(i,:);
        cost(1,i)=fcost(A,B,wtarget,lambda);
    end

    % Sort
    [cost,ind]=sort(cost,'ascend'); 
    chromosomes=chromosomes(ind,:);  
    bestIndex=ind(1);
    alphaBeta=alphaBeta(:,:,ind); % update chromosomes nodes from best to worst         
        
    % Plot best lattice
    Tb=ct(1,bestIndex)*chromosomes(1,:);
    Tbmin=ct(1,bestIndex)*tbmin;
    [nbeams2,nnodes2,nodes2,Tb2,Ob2,Eb2,delta12,delta22]=...                 
    RemoveBeams(Tbmin,Tb,nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,...
    alphaBeta,bestIndex);
    figure(1);
    PlotLattice(nodes2,nbeams2,Ob2,Eb2,Tb2,delta12,delta22,L1,L2); 
            
    meanc(1,iga)=mean(cost);  
    %iga
    minc(1,iga)=min(cost);
    %minc(1,iga)

    % convergence ?
    if (minc(1,iga)>0)
        difValue=abs((minc(1,iga)-minc(1,iga-1)))/minc(1,iga);
    else
        difValue=abs((minc(1,iga)-minc(1,iga-1)));
    end
    if (difValue<convergence)
        nlowIter=nlowIter+1;
        if (nlowIter>nConvergence) 
            break;
        end
    else
        nlowIter=0;
    end
end 
figure(2);
plot(1:iga,minc(1,1:iga));

% save best values for this try
bestChromosome=chromosomes(1,:);
bestAlphaBeta=alphaBeta(:,:,1);
bestTb=Tb;
bestCost=cost(1);
bestMS4=MS4(bestIndex,:);




