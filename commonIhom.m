% commonIhom.m
% calculate the common variables and data for a batch of lattices
% 26.08.2022
% Dos Reis F.

function [nodes,Ob, Eb,delta1,delta2]=commonIhom(sx,maillage,L)
%% inputs 
% seed : base seed number
% maillage : two types : "hexagon" or "triangle"
% L : base dimension of the lattice 

%% outputs 
% nodes : list of nodes coordinates
% Ob : origin node for beams's lattice
% Eb : ending node for beams's lattice
% delta1 : index for vector shifting direction 1
% delta2 : index for vector shifting direction 2

    Y1=[1 0];Y2=[0 1]; % definition of lattice directors assuming rectangular base cell

    if maillage=="triangle"
        seed=sx;
        L1=L ; L2=L; %length of lattice directors 
        R=L/(4*sx);
    elseif maillage=="hexagon"
        L1=L;
        l=L1/(sqrt(3)*sx);
        sy=floor(sx/sqrt(3));
        if (sy<1) 
            sy=1;
        end
        L2=3*l*sy;
        %R=L1/(2*sqrt(3)*sx);
        R=L1/(sqrt(3)*sx);    % modif temporaire 16.05
    end

    %% meshing 
    if maillage=="triangle"
        [nbeams,nnodes,nodes,Ob,Eb,delta1,delta2]=MeshTriangle(seed,L1,L2);   
    elseif maillage=="hexagon"
        [nbeams,nnodes,nodes,Ob,Eb,delta1,delta2]=MeshHexa(sx,sy,l);  
    end

end

