% embedLattice
% embed a lattice into a 3D matrix composed of layers :
% [X Y t1 t2 ... t9] ; X, Y : node location, t1 to t9 : width of the beams connected 
% with the nine neighbour cells
% 19.08.2022
% Dos Reis F.

function Mat2=embedLattice(nodes,alphaBeta,Tb,seed,Ob, Eb,delta1,delta2,L1,L2)
%% inputs :
% nodes : nodes location without random displacement alphaBeta
% alphaBeta : displacement of the node
% Tb : width of the beams
% maillage : maillage type, must be "triangle" or "hexagon"
% seed : base seed for meshing
% L1, L2 : dimensions of cell

    Mat=zeros(seed*2+4,seed*2+4,12);    % Matrix with the MATLAB indices 

    nbeams=numel(Tb);
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
        PO=alphaBeta(nO,:);                                                   
        PE=alphaBeta(nE,:);
        Mat(tabE(1),tabE(2),1)=PE(1);
        Mat(tabE(1),tabE(2),2)=PE(2);
        Mat(tabO(1),tabO(2),1)=PO(1);
        Mat(tabO(1),tabO(2),2)=PO(2);
        % Ce stockage sera effectué de manière redondante, mais c'est pas grave 

        % détermination de eb directeur de Ob -> Eb 
            % appel de toNeighbour 
            % normalisation et stockage de Tb au niveau code
            % ajout du bouclage sur soi même (code=5)
        Lb2=norm(tabE-tabO);
        eb2=([tabE(2)-tabO(2) tabO(1)-tabE(1)])/Lb2;

        codeO=toNeighbour(eb2);
        codeE=toNeighbour(-eb2);
        Mat(tabE(1),tabE(2),2+codeE)=Tb(i);
        Mat(tabO(1),tabO(2),2+codeO)=Tb(i);
        Mat(tabE(1),tabE(2),7)=1;
        Mat(tabO(1),tabO(2),7)=1;

    end
    li=(seed*2+4); co=(seed*2+4); la=12;    
    Mat2=linearShape(Mat,li,co,la); % convert a 3D Matrix in 1D Matrix  
                                % to avoid harmful effects of organization
                                % in MATLAB vs PYTHON
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
