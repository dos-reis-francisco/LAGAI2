%EvaluateCt2.m

function ct=EvaluateCt2(chromosomes,nodes,nbeams,Ob,Eb,delta1,delta2,L1,L2,rhov)

Lb=LbLattice2(nodes,nbeams,Ob,Eb,delta1,delta2,L1,L2);         
temp1=Lb*chromosomes;
ct=rhov*(L1*L2)/temp1;
