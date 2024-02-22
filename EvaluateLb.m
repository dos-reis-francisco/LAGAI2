%EvaluateLb.m

function [Lb,e]=EvaluateLb(beami,alphaBeta,nO,nE,nodes,L1,L2,delta1,delta2)
    P1ab=alphaBeta(nO,:);                                                           
    P1=nodes(nO,:)+P1ab;
    
    P2ab=alphaBeta(nE,:);                                                           
    P2=nodes(nE,:)+[L1*delta1(beami) L2*delta2(beami)]+P2ab;

    Lb=norm(P2-P1);
    e=(P2-P1)/Lb;
    