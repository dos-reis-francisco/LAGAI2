%decompos.m
% decompose la projection d'un nuage de points sur un vecteur A en :
% vecteurs normaux, vecteurs tangentiels, norme de N, norme de T

function [Nv,Tv,Nn,Tn]=decompos(TNUAGE,A)
% TNUAGE[npointsnuage, 3]
% A[n,1]
Nv=0;Tv=0;Nn=0;Tn=0;

Au=A/sqrt(A'*A);
Nn=TNUAGE*Au;
Nv=Nn.*Au';
Tv=TNUAGE-Nv;
temp1=Tv.^2;
Tn=sqrt(sum(temp1,2));
