% skin.m
% function that delivers the 'skin' of a points cloud
% Dos Reis F.
% 7.12.2022

function [TPOINTS,TSEGMENTS,TFACES]=skin(TNUAGE,fineness)

% TPOINTS[npoints,3];
% TSEGMENTS[nsegments,4]; les deux premières valeurs correspondent au 
%   numéros des points dans TPOINTS, les deux suivantes au nouveau numero de
%   segment, une fois qu'il aura été scindé
% TFACES[nfaces,3]; contient les numéros des segments
% TNUAGE[npointsnuage, 3]
% fineness : finesse de descente, correspond au degré de récursivité de
% l'algorithme

%% initialisation des tableaux
npointsnuage=size(TNUAGE,1);
npoints=6;
nsegments=12;
nfaces=8;

TPOINTS=zeros(npoints,3);
TSEGMENTS=zeros(nsegments,4);
TFACES=zeros(nfaces,3);

e=[[1 0 0];
    [0 1 0];
    [0 0 1];
    ];

minx=min(TNUAGE(:,1));maxx=max(TNUAGE(:,1));
miny=min(TNUAGE(:,2));maxy=max(TNUAGE(:,2));
minz=min(TNUAGE(:,3));maxz=max(TNUAGE(:,3));
Sk=min(abs([minx,maxx,miny,maxy,minz,maxz]))/3;
%Sk=mean(abs([minx,maxx,miny,maxy,minz,maxz]))/2;

[index,flag]=searchPoint(TNUAGE,e(1,:),Sk);
Index1=index;

[index,flag]=searchPoint(TNUAGE,-e(1,:),Sk);
Index2=index;

[index,flag]=searchPoint(TNUAGE,e(2,:),Sk);
Index3=index;

[index,flag]=searchPoint(TNUAGE,-e(2,:),Sk);
Index4=index;

[index,flag]=searchPoint(TNUAGE,e(3,:),Sk);
Index5=index;

[index,flag]=searchPoint(TNUAGE,-e(3,:),Sk);
Index6=index;


TPOINTS(1,:)=TNUAGE(Index1,:);TNUAGE(Index1,:)=[0 0 0];
TPOINTS(2,:)=TNUAGE(Index2,:);TNUAGE(Index2,:)=[0 0 0];
TPOINTS(3,:)=TNUAGE(Index3,:);TNUAGE(Index3,:)=[0 0 0];
TPOINTS(4,:)=TNUAGE(Index4,:);TNUAGE(Index4,:)=[0 0 0];
TPOINTS(5,:)=TNUAGE(Index5,:);TNUAGE(Index5,:)=[0 0 0];
TPOINTS(6,:)=TNUAGE(Index6,:);TNUAGE(Index6,:)=[0 0 0];

TSEGMENTS(1,1:2)=[1 5];
TSEGMENTS(2,1:2)=[5 3];
TSEGMENTS(3,1:2)=[2 5];
TSEGMENTS(4,1:2)=[5 4];
TSEGMENTS(5,1:2)=[1 6];
TSEGMENTS(6,1:2)=[6 3];
TSEGMENTS(7,1:2)=[2 6];
TSEGMENTS(8,1:2)=[6 4];
TSEGMENTS(9,1:2)=[3 1];
TSEGMENTS(10,1:2)=[3 2];
TSEGMENTS(11,1:2)=[4 2];
TSEGMENTS(12,1:2)=[4 1];

TFACES(1,:)=[1 2 9];
TFACES(2,:)=[2 10 3];
TFACES(3,:)=[3 4 11];
TFACES(4,:)=[4 12 1];
TFACES(5,:)=[9 6 5];
TFACES(6,:)=[10 6 7];
TFACES(7,:)=[ 7 11 8];
TFACES(8,:)=[8 12 5];

% drawskin(TPOINTS,TSEGMENTS,TFACES,TNUAGE);

%% boucle 
for step=1:fineness
    % génération des tableaux nouveau step
    npoints2=npoints+nsegments;
    nsegments2=2*nsegments+3*nfaces;
    nfaces2=4*nfaces;
    
    TSEGMENTS2=zeros(nsegments2,4);
    TFACES2=zeros(nfaces2,3);
    TPOINTS2=TPOINTS(1:npoints,:);
    pointactuel=npoints+1;
    segmentactuel=1;
    faceactuelle=1;
    
    for face=1:nfaces
        nbnouveauxpoints=0;
        % recherche des nouveaux points sur tous les segments
        for segment=1:3
            seg=TFACES(face,segment);
            % recherche nouveau point
            if ((TSEGMENTS(seg,3)==0) && (TSEGMENTS(seg,4)==0))
                P1=TSEGMENTS(seg,1);P2=TSEGMENTS(seg,2);
                P1v=TPOINTS(P1,:);P2v=TPOINTS(P2,:);
                
                Bk=(P1v+P2v)/2; % point de la ligne de direction 
                Sk=norm(P2v-P1v)/2; % distance maxi a la ligne de direction
                %
                [P3v,index,flag]=searchPointExtended(TNUAGE,Bk,Sk,P1v',P2v',200);
                %
                if (flag==0)    % on ne peut pas découper le segment
%                     TSEGMENTS2(segmentactuel,1)=P1;TSEGMENTS2(segmentactuel,2)=P2;
%                     % sauvegarde du nouveau numéro de segment
%                     TSEGMENTS(seg,3)=segmentactuel;
%                     segmentactuel=segmentactuel+1;
                    TPOINTS2(pointactuel,:)=P3v';
                    % détermination des nouveaux segments TSEGMENTS2
                    % stockage dans TSEGMENTS des segments après découpe
                    TSEGMENTS2(segmentactuel,1)=P1;TSEGMENTS2(segmentactuel,2)=pointactuel;
                    TSEGMENTS2(segmentactuel+1,1)=pointactuel;TSEGMENTS2(segmentactuel+1,2)=P2;

                    % sauvegarde des nouveaux numéros de segment
                    TSEGMENTS(seg,3)=segmentactuel;TSEGMENTS(seg,4)=segmentactuel+1; 

                    % incrémentation des compteurs 
                    pointactuel=pointactuel+1;
                    segmentactuel=segmentactuel+2;
                    nbnouveauxpoints=nbnouveauxpoints+1;
                else
                    TPOINTS2(pointactuel,:)=TNUAGE(index,:);
                    TNUAGE(index,:)=[0 0 0]; % On élimine le point A_{k} de TNUAGE
                    % détermination des nouveaux segments TSEGMENTS2
                    % stockage dans TSEGMENTS des segments après découpe
                    TSEGMENTS2(segmentactuel,1)=P1;TSEGMENTS2(segmentactuel,2)=pointactuel;
                    TSEGMENTS2(segmentactuel+1,1)=pointactuel;TSEGMENTS2(segmentactuel+1,2)=P2;

                    % sauvegarde des nouveaux numéros de segment
                    TSEGMENTS(seg,3)=segmentactuel;TSEGMENTS(seg,4)=segmentactuel+1; 

                    % incrémentation des compteurs 
                    pointactuel=pointactuel+1;
                    segmentactuel=segmentactuel+2;
                    nbnouveauxpoints=nbnouveauxpoints+1;
                end
            else
                % vérification si c'est un segment qui a déjà créé un nouveau
                % point
                if (TSEGMENTS(seg,4)~=0)
                    nbnouveauxpoints=nbnouveauxpoints+1;
                    
                end
                
            end
        end
        % détermination des nouveaux segments a ajouter
        % suivant le nombre de nouveaux points créés
        if (nbnouveauxpoints==3)
            % A partir des trois points A_{k}: ajout des trois segments 
            % transversaux de la facettes dans TSEGMENT2
            seg1old=TFACES(face,1);seg2old=TFACES(face,2);seg3old=TFACES(face,3);
            [listesegnew,listepoints]=ordonneSeg(seg1old,seg2old,seg3old,TSEGMENTS,TSEGMENTS2);
            seg1=listesegnew(1);seg2=listesegnew(2);seg3=listesegnew(3);
            seg4=listesegnew(4);seg5=listesegnew(5);seg6=listesegnew(6);
            %
            P1=listepoints(1);P2=listepoints(2);P3=listepoints(3);
            P4=listepoints(4);P5=listepoints(5);P6=listepoints(6);
            %
            TSEGMENTS2(segmentactuel,1)=P4;TSEGMENTS2(segmentactuel,2)=P2;
            TSEGMENTS2(segmentactuel+1,1)=P6;TSEGMENTS2(segmentactuel+1,2)=P4;
            TSEGMENTS2(segmentactuel+2,1)=P2;TSEGMENTS2(segmentactuel+2,2)=P6;
            seg7=segmentactuel+2;        seg8=segmentactuel;    seg9=segmentactuel+1;
            segmentactuel=segmentactuel+3;
            % détermination de 4 facettes
            TFACES2(faceactuelle,1)=seg1;TFACES2(faceactuelle,2)=seg7;TFACES2(faceactuelle,3)=seg6;
            TFACES2(faceactuelle+1,1)=seg2;TFACES2(faceactuelle+1,2)=seg3;TFACES2(faceactuelle+1,3)=seg8;
            TFACES2(faceactuelle+2,1)=seg4;TFACES2(faceactuelle+2,2)=seg5;TFACES2(faceactuelle+2,3)=seg9;
            TFACES2(faceactuelle+3,1)=seg7;TFACES2(faceactuelle+3,2)=seg9;TFACES2(faceactuelle+3,3)=seg8;

            %
            faceactuelle=faceactuelle+4;
        elseif (nbnouveauxpoints==2)
            seg1old=TFACES(face,1);seg2old=TFACES(face,2);seg3old=TFACES(face,3);
            [seg1old,seg2old,seg3old]=rotateSegment(seg1old,seg2old,seg3old,TSEGMENTS);
            [listesegnew,listepoints]=ordonneSeg(seg1old,seg2old,seg3old,TSEGMENTS,TSEGMENTS2);
            seg1=listesegnew(1);seg2=listesegnew(2);seg3=listesegnew(3);
            seg5=listesegnew(5);seg6=listesegnew(6);
            %
            P1=listepoints(1);P2=listepoints(2);P3=listepoints(3);
            P4=listepoints(4);P5=listepoints(5);P6=listepoints(6);
            %
            TSEGMENTS2(segmentactuel,1)=P2;TSEGMENTS2(segmentactuel,2)=P6;
            TSEGMENTS2(segmentactuel+1,1)=P5;TSEGMENTS2(segmentactuel+1,2)=P2;
            seg7=segmentactuel; seg8=segmentactuel+1;
            segmentactuel=segmentactuel+2;
            % inversion de seg5
            %TSEGMENTS2(seg5,1)=P6;TSEGMENTS2(seg5,2)=P5;
            % creation de 3 facettes
            TFACES2(faceactuelle,1)=seg1;TFACES2(faceactuelle,2)=seg7;TFACES2(faceactuelle,3)=seg6;
            TFACES2(faceactuelle+1,1)=seg2;TFACES2(faceactuelle+1,2)=seg3;TFACES2(faceactuelle+1,3)=seg8;
            TFACES2(faceactuelle+2,1)=seg7;TFACES2(faceactuelle+2,2)=seg8;TFACES2(faceactuelle+2,3)=seg5;
            faceactuelle=faceactuelle+3;
        elseif (nbnouveauxpoints==1)
            seg1old=TFACES(face,1);seg2old=TFACES(face,2);seg3old=TFACES(face,3);
            [seg1old,seg2old,seg3old]=rotateSegment(seg1old,seg2old,seg3old,TSEGMENTS);
            [listesegnew,listepoints]=ordonneSeg(seg1old,seg2old,seg3old,TSEGMENTS,TSEGMENTS2);
            seg1=listesegnew(1);seg2=listesegnew(2);seg3=listesegnew(3);
            seg4=listesegnew(4);seg5=listesegnew(5);seg6=listesegnew(6);
            %
            P1=listepoints(1);P2=listepoints(2);P3=listepoints(3);
            P4=listepoints(4);P5=listepoints(5);P6=listepoints(6);
            %
            TSEGMENTS2(segmentactuel,1)=P2;TSEGMENTS2(segmentactuel,2)=P5;
            seg7=segmentactuel;
            segmentactuel=segmentactuel+1;
            % inversion de deux segments seg4 et seg2
           % TSEGMENTS2(seg2,1)=P3;TSEGMENTS2(seg2,2)=P2;
           % TSEGMENTS2(seg4,1)=P5;TSEGMENTS2(seg4,2)=P3;
            % création de deux facettes 
            TFACES2(faceactuelle,1)=seg1;TFACES2(faceactuelle,2)=seg7;TFACES2(faceactuelle,3)=seg5;
            TFACES2(faceactuelle+1,1)=seg2;TFACES2(faceactuelle+1,2)=seg7;TFACES2(faceactuelle+1,3)=seg3;
            faceactuelle=faceactuelle+2;
        elseif (nbnouveauxpoints==0)
            seg1old=TFACES(face,1);seg2old=TFACES(face,2);seg3old=TFACES(face,3);
            seg1=TSEGMENTS(seg1old,3);seg2=TSEGMENTS(seg2old,3);seg3=TSEGMENTS(seg3old,3);
            % création d'une facette 
             TFACES2(faceactuelle,1)=seg1;TFACES2(faceactuelle,2)=seg2;TFACES2(faceactuelle,3)=seg3;
            faceactuelle=faceactuelle+1;
        end
        
    end
    
    % copie des variables et tableaux
    TSEGMENTS2(1:segmentactuel-1,3:4)=0;
    npoints=pointactuel-1;   nsegments=segmentactuel-1;   nfaces=faceactuelle-1;
    
    TPOINTS=TPOINTS2(1:npoints,:);   TSEGMENTS=TSEGMENTS2(1:nsegments,:);
    TFACES=TFACES2(1:nfaces,:);
%    drawskin(TPOINTS,TSEGMENTS,TFACES,TNUAGE);
end

end

function [seg1old,seg2old,seg3old]=rotateSegment(seg1old,seg2old,seg3old,TSEGMENT)
% function that delivers a sequence of segment :
% first : split segment
% second : non split segment
% third : indifferent
while ((TSEGMENT(seg1old,4)==0)||(TSEGMENT(seg2old,4)~=0))
    temp=seg1old; seg1old=seg2old; seg2old=seg3old; seg3old=temp;
end
end 

function r=testCoherence(TFACES,TSEGMENTS,i)
    seg1=TFACES(i,1);seg2=TFACES(i,2);seg3=TFACES(i,3);
    P1=TSEGMENTS(seg1,1);P2=TSEGMENTS(seg2,1);P3=TSEGMENTS(seg3,1);
    if ((P1==P2) || (P2==P3) || (P3==P1))
        "erreur : points identiques dans une face"
        r=-1;
    end
    r=0;
end

% fonction qui fournit une liste de ordonnées à
% partir des tableaux, sachant que le sens des segments
% peut être quelconque
function [listesegnew,listepoints]=ordonneSeg(seg1old,seg2old,seg3old,TSEGMENTS,TSEGMENTS2)
% fonction qui renvoie la séquence ordonnée des points de la face i
% après découpage des segments
    listesegnew=zeros(6,1);
    listepoints=zeros(6,1);
    PO1=TSEGMENTS(seg1old,1);
    PE1=TSEGMENTS(seg1old,2);
    PO2=TSEGMENTS(seg2old,1);
    PE2=TSEGMENTS(seg2old,2);
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
    %
    if ((TSEGMENTS(seg1old,3)==0)||(TSEGMENTS(seg2old,3)==0)||(TSEGMENTS(seg3old,3)==0))
        "erreur face non traitée entièrement"
    end
    %
    division1=0;division2=0;division3=0;
    P1I=0;P2I=0;P3I=0;
    if (TSEGMENTS(seg1old,4)~=0)
        division1=1;
        seg=TSEGMENTS(seg1old,3);
        P1I=TSEGMENTS2(seg,2);
    end
    
    if (TSEGMENTS(seg2old,4)~=0)
        division2=1;
        seg=TSEGMENTS(seg2old,3);
        P2I=TSEGMENTS2(seg,2);
    end
    
    if (TSEGMENTS(seg3old,4)~=0)
        division3=1;
        seg=TSEGMENTS(seg3old,3);
        P3I=TSEGMENTS2(seg,2);
    end
    %
    listepoints(1)=PO1;listepoints(2)=P1I;listepoints(3)=PO2;
    listepoints(4)=P2I;listepoints(5)=PO3;listepoints(6)=P3I;
    
    %
    seg1=TSEGMENTS(seg1old,3);seg2=TSEGMENTS(seg1old,4);
    if ((division1==1)&&(inversion1==1))
        t=seg1;seg1=seg2;seg2=t;
    end

    seg3=TSEGMENTS(seg2old,3);seg4=TSEGMENTS(seg2old,4);
    if ((division2==1)&&(inversion2==1))
        t=seg3;seg3=seg4;seg4=t;
    end
    seg5=TSEGMENTS(seg3old,3);seg6=TSEGMENTS(seg3old,4);
    if ((division3==1)&&(inversion3==1))
        t=seg5;seg5=seg6;seg6=t;
    end
    listesegnew(1)=seg1;listesegnew(2)=seg2;listesegnew(3)=seg3;
    listesegnew(4)=seg4;listesegnew(5)=seg5;listesegnew(6)=seg6;
end


