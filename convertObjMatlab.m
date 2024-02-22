% convertObjMatlab.m
% convert a skin model in matlab obj display 
% Dos Reis F
% 8.12.2022

function [verts,faces,cindex]=convertObjMatlab(TPOINTS,TSEGMENTS,TFACES)
nfaces=size(TFACES,1);
nverts=size(TPOINTS,1);

verts=TPOINTS;
faces=zeros(nfaces,3);
cindex=zeros(nverts,3);
minx=min(TPOINTS(:,1));miny=min(TPOINTS(:,2));minz=min(TPOINTS(:,3));
maxx=max(TPOINTS(:,1));maxy=max(TPOINTS(:,2));maxz=max(TPOINTS(:,3));
etx=maxx-minx;
ety=maxy-miny;
etz=maxz-minz;

for i=1:nverts
   PZ=TPOINTS(i,3); 
   cindex(i,1)=(PZ-minz)/(etz);
   cindex(i,2)=0.1;
end

for i=1:nfaces
    seg1=TFACES(i,1);seg2=TFACES(i,2);seg3=TFACES(i,3);
    [P1,P2,P3]=ordonneSeg2(seg1,seg2,seg3,TSEGMENTS);
    if ((P1==P2) || (P2==P3) || (P3==P1))
        "erreur : points identiques dans une face"
        return
    end
    faces(i,1)=P1;faces(i,2)=P2;faces(i,3)=P3;

end
end

% fonction qui fournit une liste de ordonnées à
% partir des tableaux, sachant que le sens des segments
% peut être quelconque
function [PO1,PO2,PO3]=ordonneSeg2(seg1old,seg2old,seg3old,TSEGMENTS)
% fonction qui renvoie la séquence ordonnée des points de la face i
% après découpage des segments
    PO1=TSEGMENTS(seg1old,1);
    PE1=TSEGMENTS(seg1old,2);
    PO2=TSEGMENTS(seg2old,1);
    PE2=TSEGMENTS(seg2old,2);
    inversion2=0;
    inversion2=0;
    inversion1=0;
    if (PE1~=PO2) 
        if (PE1==PE2)      
            inversion2=1;
            t=PO2;PO2=PE2;PE2=t;
        end
        if (PO1==PO2)
            inversion1=1;
            t=PO1;PO1=PE1;PE1=t;
        end
        if (PO1==PE2)      
            inversion2=1;
            t=PO2;PO2=PE2;PE2=t;
            inversion1=1;
            t=PO1;PO1=PE1;PE1=t;
        end
        if ((inversion1==0)&&(inversion2==0))
            "erreur pas de continuité"
        end
    end
    %
    PO3=TSEGMENTS(seg3old,1);
    PE3=TSEGMENTS(seg3old,2);
    inversion3=0;
    if (PE2~=PO3) 
        inversion3=1;
        t=PO3;PO3=PE3;PE3=t;
        if (PE2~=PO3)
            "erreur séquence segments"
            return
        end
    end
   
end


