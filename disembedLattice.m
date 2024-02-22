% disembedLattice.m
% re create matrices lattice from a 3D embedded 
% 26.08.2022
% Dos Reis F.

function [Tb,nodes,Ob,Eb,delta1,delta2]=disembedLattice(mat_lin,seed)
%% inputs
% mat_lin : matrix 3D linearised
% seed : basic number of slices
% L : basic dimension of lattice
% ntmax : max number for width t

%% outputs
% Tb : width t in range tmin -> ntmax (must be adjusted by ct)
% nodes : nodes coordinates including alphaBeta in real dimensions
% Ob, Eb : number of origin and ending nodes
% delta1, delta2 : shifting vectors

%% code
L=1;
longueurPoutres=2*L+2*L*sqrt(2);
VolumeMatiere=0.2*L*L;
MaxTb=2*VolumeMatiere/longueurPoutres;
% reshaping mat3D
    mat3D=linear_to_3D(mat_lin,seed);    % Matrix with the MATLAB indices 
% recreation du maillage --> nodes Ob, Eb, delta1, delta2
[nodes,Ob, Eb,delta1,delta2]=commonIhom(seed,"triangle",L);
L1=L;
L2=L;
R=L/(4*seed);
% reprise de embedLattice, mais en lecture et non pas en stoquage
    nbeams=numel(Ob);
    alphaBeta=zeros(size(nodes));
    Tb=zeros(nbeams,1);
    % boucle sur les poutres
    for i=1:nbeams
        % appel de la fonction toTab avec les coordonnées de nodes Eb et Ob
        % posOrg
        nO=Ob(i);
        nE=Eb(i);
        P1=nodes(nO,:);                                                   
        P2=nodes(nE,:)+[L1*delta1(i) L2*delta2(i)];

        Lb=norm(P2-P1);
        eb=(P2-P1)/Lb;
        tabO=toTab(P1,seed,L1,L2);
        tabE=toTab(P2,seed,L1,L2);

        % normalisation et stockage dans les deux premières couches des 
        % displacement of the node alphaBeta : [x, y] 

        PE(1)=mat3D(tabE(1),tabE(2),1);
        PE(2)=mat3D(tabE(1),tabE(2),2);
        PO(1)=mat3D(tabO(1),tabO(2),1);
        PO(2)=mat3D(tabO(1),tabO(2),2);

        alphaBeta(nO,:)=PO;  
        alphaBeta(nE,:)=PE;
        
        % Ce stockage sera effectué de manière redondante, mais c'est pas grave 

        % détermination de eb directeur de Ob -> Eb 
            % appel de toNeighbour 
            % normalisation et stockage de Tb au niveau code
            % ajout du bouclage sur soi même (code=5)
        Lb2=norm(tabE-tabO);
        eb2=([tabE(2)-tabO(2) tabO(1)-tabE(1)])/Lb2;

        codeO=toNeighbour(eb2);
        codeE=toNeighbour(-eb2);
        Tb(i)=mat3D(tabE(1),tabE(2),2+codeE);
        Tb(i)=Tb(i)+mat3D(tabO(1),tabO(2),2+codeO);
        Tb(i)=Tb(i)/2;
    end
 
% initial dimensions : alphaBeta, Tb
alphaBeta=alphaBeta*2*R-R;
Tb=Tb*MaxTb;

% recalculate nodes + alphaBeta
nodes=nodes+alphaBeta;
end




% function toNeighbour 
   % détermination du numéro de voisin en fonction de eb 
function code=toNeighbour(eb)
    if (eb(1)<0)
        if (eb(2)>0)
            code=1;
            return;
        end
        if (eb(2)==0)
            code=4;
            return;
        end 
        if (eb(2)<0)
            code=7;
            return;
        end
    end
    if (eb(1)==0)
        if (eb(2)>0)
            code=2;
            return;
        end
        if (eb(2)==0) % impossible!
            code=5;
            return;
        end 
        if (eb(2)<0)
            code=8;
            return;
        end
    end
    if (eb(1)>0)
        if (eb(2)>0)
            code=3;
            return;
        end
        if (eb(2)==0)
            code=6;
            return;
        end 
        if (eb(2)<0)
            code=9;
            return;
        end
    end
end

% function toTab
function tab=toTab(P,seed,L1,L2)

    C=[L1/2 L2/2];
    % translation au centre 
    P1=P-C;
    s1=L1/seed; s2=L2/seed;
    P1(1)=P1(1)/s1;
    P1(2)=P1(2)/s2;
    
    % calcul de la position après rotation et changement de coordonnées 
    R=[[1 1]; [-1 1]];
    P2=R*P1';
   
    % translation inverse pour centrer le treillis dans le tableau avec les
    T1=seed+1;
    T2=[T1 T1];

    % nouvelles coordonnées [X, Y]
    P3=P2'+T2+[1 1]; % les coordonnées de tableau commence à 1 
    
    % conversion de [X, Y] la position en [lignes, colonnes] de tableau
    tab=round([(seed*2+4-P3(2)) P3(1)]);
end
