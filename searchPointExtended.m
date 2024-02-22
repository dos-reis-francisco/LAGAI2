%searchPoint.m

function [P3,index,flag]=searchPointExtended(TNUAGE,Bk,Sk,P1,P2,radiusMin)
% index : numero du point
% flag : 1 point proche de la droite de projection (distance max Sk)
%         0 : point éloigné de la droite de projection (distance max Sk)
% TNUAGE : nuage de points
% Bk : point de la ligne de direction
% Sk : distance maxi à la ligne de direction
% P1 : point 1 de l'arc potentiel
% P2 : point 2 de l'arc
% radiusMin : rayon mini, tel que le point trouvé doit avec P1 et P2
% définir un arc de rayon mini radiusMin
npointsnuage=size(TNUAGE(:,1));

[Nv,Tv,Nn,Tn]=decompos(TNUAGE,Bk');
flag=0;

for i=1:npointsnuage
    [MaxNn,index]=max(Nn);
    if Tn(index)<Sk
        flag=1;
        P3=TNUAGE(index,:)';
        P3=SmoothSkin(P1,P2,P3,radiusMin);
        return;
    else
        Nn(index)=0;
    end
end
flag=0;
P3=[0;0;0];
P3=SmoothSkin(P1,P2,P3,radiusMin);
end