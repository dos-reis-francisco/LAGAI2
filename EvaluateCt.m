%EvaluateCt.m

function ct=EvaluateCt(nchromosomes,chromosomes,nodes,nbeams,Ob,Eb,delta1,...
    delta2,L1,L2,rhov,alphaBeta)
ct=zeros(1,nchromosomes);
for i=1:nchromosomes 

Lb=LbLattice(nodes,nbeams,Ob,Eb,delta1,delta2,L1,L2,alphaBeta(:,:,i));         
temp1=Lb*chromosomes(i,:)';
ct(1,i)=rhov*(L1*L2)/temp1;

end