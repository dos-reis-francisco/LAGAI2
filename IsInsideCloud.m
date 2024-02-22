function [f,PClosed]=IsInsideCloud(A,C)
V=C-A;
V2=V.^2;
V3=sum(V2,2);
[V4,index]=sort(V3);
P=zeros(4,3);
P(1,:)=C(index(1),:);
P(2,:)=C(index(2),:);
P(3,:)=C(index(3),:);
P(4,:)=C(index(4),:);
f=IsInsidePolyhedron(A,P);
if (f~=1)
    PClosed=P(1,:);
else
    PClosed=A;
end
end