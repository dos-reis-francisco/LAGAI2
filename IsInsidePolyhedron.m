% IsInsidePolyhedron.m
% A : point  
% P : matrix of four points polyhedron 
% f : boolean result

function f=IsInsidePolyhedron(A,P)
    V=P-A;
    f1=V(1,:)*V(2,:)';
    f2=V(1,:)*V(3,:)';
    f3=V(1,:)*V(4,:)';
    f=((f1>0)&&(f2>0)&&(f3>0));
    f=~f;
end