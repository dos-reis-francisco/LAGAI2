%test du format d'enregistrement hdf5 pour une récupération avec PYTHON
a=zeros(4,3,5);

for la=1:5
    for li=1:4
        for co=1:3
            a(li,co,la)=1000+li*100+co*10+la;
        end 
    end
end

b=zeros(4,3,5);

for la=1:5
    for li=1:4
        for co=1:3
            b(li,co,la)=2000+li*100+co*10+la;
        end 
    end
end

train_data=zeros(60,2);
train_data(:,1)=linearShape(a,4,3,5);
train_data(:,2)=linearShape(b,4,3,5);
train_data=reshape(train_data,120,1);
h5create("test7.hdf5",'/train_data',120);
h5write("test7.hdf5",'/train_data',train_data);