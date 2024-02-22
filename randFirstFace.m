% randFirstFace.m
% function that calculate a random point on a specific face 
% 27.01.2023
% Dos Reis F.

function [Ex_n,nuxy_n,rhov_n]=randFirstFace(NumeroFaceEnCours,TPOINTS,TSEGMENTS,TFACES)

    [Pt1, Pt2, Pt4]=extractPoint(NumeroFaceEnCours,TPOINTS,TSEGMENTS,TFACES);
    
    U=Pt2-Pt1;
    V=Pt4-Pt1;
    
    % calcul de coordonnées aléatoires sur la face triangulaire 
    u=rand();
    v=rand()*(1-u);
    
    % Point trouvé sur le triangle 
    PtFound=Pt1+u*U+v*V;
    
    Ex_n=PtFound(1);
    nuxy_n=PtFound(2);
    rhov_n=PtFound(3);
end