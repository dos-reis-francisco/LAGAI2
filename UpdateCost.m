%%Updatecost.m

function [MExtracted,MS4,cost]=UpdateCost(chromosomes,nchromosomes,ct,target,wtarget,lambda)
MS4=zeros(nchromosomes,6); %contain compliance tensors of each chromosomes
MExtracted=zeros(nchromosomes,10);
cost=zeros(1,nchromosomes); % score of chromosomes
% Homogenization & cost for each chromosome
for i=1:nchromosomes
    %todo : mettre les quatres lignes suivantes en sous programme car elles
    %apparaissent deux fois
    Tb=ct(1,i)*chromosomes(i,:);
    %todo : suppression adaptative de la largeur minimale des poutres
    [MExtracted(i,:),MS4(i,:)]=homogenization(Tb);
    A=target;B=MS4(i,:);
    %todo ajouter une pénalisation adaptative de type 7. pénalisation de 
    % type Bean et Hadj-Alouane ou un calcul de la
    % pénalisation directement basée sur les coefficients de wtarget
    cost(1,i)=fcost(A,B,wtarget,lambda);
end
