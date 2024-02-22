%searchPoint.m

function [index,flag]=searchPoint(TNUAGE,Bk,Sk)
% index : numero du point
% flag : 1 point proche de la droite de projection (distance max Sk)
%         0 : point éloigné de la droite de projection (distance max Sk)
npointsnuage=size(TNUAGE(:,1));

[Nv,Tv,Nn,Tn]=decompos(TNUAGE,Bk');
flag=0;
for i=1:npointsnuage
    [MaxNn,index]=max(Nn);
    if Tn(index)<Sk
        flag=1;
        break;
    else
        Nn(index)=0;
    end
end
end