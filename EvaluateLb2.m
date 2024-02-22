%EvaluateLb2.m

function [Lb,e]=EvaluateLb2(beami,nO,nE,nodes,L1,L2,delta1,delta2)
                                                          
    P1=nodes(nO,:);
                                                             
    P2=nodes(nE,:)+[L1*delta1(beami) L2*delta2(beami)];

    Lb=norm(P2-P1);
    e=(P2-P1)/Lb;
    