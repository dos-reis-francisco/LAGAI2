%% MeshHexa
% create the mesh of the lattice hexagonal
% sub module for inverse homogenization code
% Dos Reis F.
% 30.01.2022

% L1,L2,Y1,Y2,nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,Elast, Lb

% il faudrait que je le fasse
function [nbeams,nnodes,nodes,Ob,Eb,delta1,delta2]=MeshHexa(sx,sy,l)
    NL=sy; NC=sx;
    L1s=l*sqrt(3);L2s=3*l;
    nbeams=6*NL*NC;
    nnodes=NL*NC*4;
    nodes=zeros(nnodes,2);
    Ob=zeros(nbeams,1);
    Eb=zeros(nbeams,1);
    delta1=zeros(nbeams,1);
    delta2=zeros(nbeams,1);

    beam=1;
    for L=1:NL
        for C=1:NC
            % first beam
            type=1;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n1=numbernode;
            nodes(numbernode,1:2)=node;
            type=2;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n2=numbernode;
            nodes(numbernode,1:2)=node;
			
            Ob(beam)=n1;Eb(beam)=n2;
            beam=beam+1;
            % second beam
            type=4;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n4=numbernode;
            nodes(numbernode,1:2)=node;
            Ob(beam)=n2;Eb(beam)=n4;
            beam=beam+1;
            
            % third beam
            type=5;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n5=numbernode;
            delta1(beam)=d1;delta2(beam)=d2;
            Ob(beam)=n2;Eb(beam)=n5;
            beam=beam+1;
            % fourth beam
            type=6;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n6=numbernode;
            delta1(beam)=d1;delta2(beam)=d2;
            Ob(beam)=n4;Eb(beam)=n6;
            beam=beam+1;
			% fifth beam
            type=3;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n3=numbernode;
            nodes(numbernode,1:2)=node;
            Ob(beam)=n4;Eb(beam)=n3;
            beam=beam+1;
            % sixth beam
            type=7;
            [numbernode,d1,d2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l);
            n7=numbernode;
            Ob(beam)=n3;Eb(beam)=n7;
            delta1(beam)=d1;delta2(beam)=d2;
            beam=beam+1;
        end
    end
end

%% function NumNodeHexa
% return the number node and deltai values 
% type : 1 .. 7 type of node in cell
% NC : number of cell in columns
% NL : number of cell in lines
% C : column treated
% L : line treated
% L1s : width of a elementary cell
% L2s : height of a elementary cell

function [numbernode,delta1,delta2,node]=NumNodeHexa(type,NC,NL,C,L,L1s,L2s,l)
    e1=[sqrt(3)/2 1/2];
    e2=[0 1];
    e5=[-sqrt(3)/2 1/2];
    node=zeros(2,1);
    if type==1 
        numbernode=(L-1)*NC*4+(C-1)*4+1;
        delta1=0;
        delta2=0;
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0;
    elseif type==2
        numbernode=(L-1)*NC*4+(C-1)*4+2;
        delta1=0;
        delta2=0;      
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0+l*e1;
    elseif type==3
        numbernode=(L-1)*NC*4+(C-1)*4+3;
        delta1=0;
        delta2=0;
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0+l*(e1+e2+e5);
    elseif type==4
        numbernode=(L-1)*NC*4+(C-1)*4+4;
        delta1=0;
        delta2=0;
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0+l*(e1+e2);
    elseif type==5
        delta2=0;
        if (C+1)<=NC
            C=C+1;
            delta1=0;
        else
            C=1;
            delta1=1;
        end
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0;
        numbernode=(L-1)*NC*4+(C-1)*4+1;  
    elseif type==6
        delta2=0;
        if (C+1)<=NC
            C=C+1;
            delta1=0;
        else
            C=1;
            delta1=1;
        end
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0+l*(e1+e2+e5);
        numbernode=(L-1)*NC*4+(C-1)*4+3; 
        
    elseif type==7
        delta1=0;
        if (L+1)<=NL
            L=L+1;
            delta2=0;
        else
            L=1;
            delta2=1;
        end
        Pos0=[(C-1)*L1s (L-1)*L2s];
        node=Pos0;
        numbernode=(L-1)*NC*4+(C-1)*4+1; 
    end
end