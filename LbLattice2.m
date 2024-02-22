%LbLattice2.m

function Lb=LbLattice2(nodes,nbeams,Ob,Eb,delta1,delta2,L1,L2)
Lb=zeros(1,nbeams);
% u=[L1/(4*seed) L2/(4*seed)];
% v=[-L1/(4*seed) L2/(4*seed)];
for i=1:nbeams
    nO=Ob(i);
    nE=Eb(i);
    
%     P1ab=alphaBeta(nO,:);
%     P1=nodes(nO,:)+P1ab(1)*u+P1ab(2)*v;
%     
%     P2ab=alphaBeta(nE,:);
%     P2=nodes(nE,:)+[L1*delta1(i) L2*delta2(i)]+P2ab(1)*u+P2ab(2)*v;
% 
%     Lb(i)=norm(P2-P1);
    [Lb(i),e]=EvaluateLb3(i,nO,nE,nodes,L1,L2,delta1,delta2);          %*
end
