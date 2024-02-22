%PlotLattice.m

function PlotLattice2(nodes,nbeams,Ob,Eb,Tb,delta1,delta2,L1,L2)
f=gcf;
x=[0 L1 L1 0];
y=[0 0 L2 L2];
plot(x,y,'-');
scale=f.Position(3)/L1;
hold on
for i=1:nbeams
    nO=Ob(i); nE=Eb(i);
%     x1(1)=nodes(nO,1);
%     x1(2)=nodes(nE,1)+delta1(i)*L1;
%     y1(1)=nodes(nO,2);
%     y1(2)=nodes(nE,2)+delta2(i)*L2;
    
                                                         
    P1=nodes(nO,:);
    
                                                         
    P2=nodes(nE,:)+[L1*delta1(i) L2*delta2(i)];
    
    x1=[P1(1) P2(1)];
    y1=[P1(2) P2(2)];
    
    if (Tb(i)>0.0) 
        plot(x1,y1,'-b','LineWidth',scale*Tb(i));
    end
end
hold off;