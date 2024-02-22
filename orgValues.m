% orgValues.m
% Dos Reis F.
% 6.02.2023
% convert normalized values into their original values
% [Ex, Ey, rhov] --> obtained by normlisation 1 and multiplied by scaleNuage  
% [Ey, Gxy, nuxy] --> obtained by normlisation 2 and multiplied by scaleNuage
% hypothèse pour Ey : valeures normalisées soient identiques

function [Ex,Ey,Gxy,nuxy,rhov]=orgValues(Ex_n,Ey_n,Gxy_n,nuxy_n,rhov_n,moyenne1,...
    ecartType1,moyenne2,ecartType2,scaleNuage)
    diffEcartTypeEy=abs((ecartType1(2)-ecartType2(1))/ecartType1(2));
    diffMoyenneEy=abs((moyenne1(2)-moyenne2(1))/moyenne1(2));
    if ((diffEcartTypeEy>0.01) ||(diffMoyenneEy>0.01)) 
        disp("Erreurs : valeurs ecart type ou moyenne trop éloignée sur les deux nuages");
    end
    Ex1=Ex_n/scaleNuage;
    Ey1=Ey_n/scaleNuage;
    Gxy2=Gxy_n/scaleNuage;
    nuxy2=nuxy_n/scaleNuage;
    rhov1=rhov_n/scaleNuage;
    
    Ex=Ex1*ecartType1(1)+moyenne1(1);
    Ey=(Ey1)*ecartType1(2)+moyenne1(2);
    rhov=(rhov1)*ecartType1(3)+moyenne1(3);
    Gxy=(Gxy2)*ecartType2(2)+moyenne2(2);
    nuxy=(nuxy2)*ecartType2(3)+moyenne2(3);
end 