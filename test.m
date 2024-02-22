% test de la linéarisation des données avec MATLAB 
a=zeros(4,3,5);
for li=1:4
    for co=1:3
        a(li,co,:)=[1 2 3 4 5]*li*co;
    end 
end

b=zeros(4*3*5,1);
lco=5; lli=lco*3;
for li=1:4
    for co=1:3
        base=(li-1)*lli+(co-1)*lco+1;
        b(base:base+4)=a(li,co,:);
    end 
end
b