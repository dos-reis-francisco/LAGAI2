%RemoveBeams.m
%remove the most weakest beams of a lattice
% Dos Reis Francisco
% 17.01.2022
function [nbeams2,nnodes2,nodes2,Tb2,Ob2,Eb2,delta12,delta22]=...
RemoveBeams(Tbmin,Tb,nbeams,nnodes,nodes,Ob,Eb,delta1,delta2,alphaBeta,chromosomei)

selectBeams=Tb>Tbmin;

flag=1;
% eliminate beams with Tb<Tbmin
% count the number of nodes linked with a beam
while (flag==1)
    flag=0;
    selectNodes=zeros(1,nnodes);
    for i=1:nbeams
        if (selectBeams(1,i)==1)
            selectNodes(1,Ob(i))=selectNodes(1,Ob(i))+1;
            selectNodes(1,Eb(i))=selectNodes(1,Eb(i))+1;
        end
    end
    for i=1:nnodes
        if (selectNodes(1,i)==1)
            selectBeams=selectBeams-((Ob==i)+(Eb==i))';
            flag=1;
        end
    end
end

% remove nodes unused
nnodes2=0;
tabCorrespondance=zeros(1,nnodes);
nodes2=zeros(nnodes,2);
%alphaBeta2=alphaBeta;                                                           %*
for i=1:nnodes
    if (selectNodes(1,i)>1)
        nnodes2=nnodes2+1;
        tabCorrespondance(1,i)=nnodes2;
        nodes2(nnodes2,:)=nodes(i,:)+alphaBeta(i,:,chromosomei);
       % alphaBeta2(nnodes2,:,chromosomei)=alphaBeta(i,:,chromosomei);           %*
    else
        tabCorrespondance(1,i)=0;
    end
end

nbeams2=0;
Ob2=zeros(nbeams,1);
Eb2=zeros(nbeams,1);
delta12=zeros(nbeams,1);
delta22=zeros(nbeams,1);
Tb2=zeros(1,nbeams);
% update array governing beam's lattice : Ob, Eb, Tb, delta1, delta2
for i=1:nbeams
    if (selectBeams(i)==1) 
        nbeams2=nbeams2+1;
        nOb=Ob(i);
        nEb=Eb(i);
        Ob2(nbeams2)=tabCorrespondance(nOb);
        Eb2(nbeams2)=tabCorrespondance(nEb);
        delta12(nbeams2)=delta1(i);
        delta22(nbeams2)=delta2(i);
        Tb2(nbeams2)=Tb(i);
    end
end




