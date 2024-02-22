%% fcost.m
% cost function for the genetic algorithm 
% sub module for inverse homogenization code
% Dos Reis F.
% 02.2021
function cost = fcost(A,B,w,lambda)
normeA=sqrt(A*A');
normeB=sqrt(B*B');
ExEyA=sqrt(A(1)*A(1)+A(2)*A(2));
ExEyB=sqrt(B(1)*B(1)+B(2)*B(2));
D1=A/normeA;
D2=B/normeB;
D=D1-D2;
D3=D.*w;
cost=sqrt(D3*D3')+lambda*ExEyB/ExEyA;
end

