A=[1 10 20 35; 2 15 22 38; 3 20 25 41; 4 5 24 44; 5 0 26 47];
 moyenne=mean(A,1);
 ecart_type=std(A,0,1);
 
 D=ones(5,1);
 E=D.*(moyenne);
 F=D.*(ecart_type);
 
 G=A-E;
 H=(G./F);
 
