% testPEEL2.m
% Dos Reis F.
% 26.12.2022
%file1="..\\..\\python\\deepl\\data_seed4_80K_2K_6K_Chro128_Conv003_MaxIt_2K.h5";
%file2="..\\..\\python\\deepl\\data_seed4_10K_05K_1K.h5";
file1="data15.hdf5";
number_data=50000;
number_test=5000;
seed=2;
file_output="data16.h5"

[data,y]=readHdf5database(file1,"/train_data","/train_y",number_data,seed);

y2=reshape(y,5,number_data);

% je ne travaille que sur les points extrêmes Ex, Ey, nuxy
TNUAGE=100*normalize(y2([1 2 4],:)');
[TPOINTS,TSEGMENTS,TFACES]=skin(TNUAGE,3);
drawskin(TPOINTS,TSEGMENTS,TFACES,TNUAGE);
[PEEL_CLOUD,index]=PEEL(TPOINTS,TSEGMENTS,TNUAGE);
drawskin(TPOINTS,TSEGMENTS,TFACES,PEEL_CLOUD);
PointRetenus=size(index,1);
y3=y2(:,index);
train_y=reshape(y3,PointRetenus*5,1);

size_data=(seed*2+4)*(seed*2+4)*12;
data2=reshape(data,size_data,number_data);
data3=data2(:,index);
train_data=reshape(data3,PointRetenus*size_data,1);
train_number=PointRetenus;

% Je refais la même sélection avec les données de test
[data,y]=readHdf5database(file1,"/test_data","/test_y",number_test,seed);

y2=reshape(y,5,number_test);

TNUAGE=100*normalize(y2([1 2 4],:)');
[TPOINTS,TSEGMENTS,TFACES]=skin(TNUAGE,3);
drawskin(TPOINTS,TSEGMENTS,TFACES,TNUAGE);
[PEEL_CLOUD,index]=PEEL(TPOINTS,TSEGMENTS,TNUAGE);
drawskin(TPOINTS,TSEGMENTS,TFACES,PEEL_CLOUD);
PointRetenus=size(index,1);
y3=y2(:,index);
test_y=reshape(y3,PointRetenus*5,1);

data2=reshape(data,size_data,number_test);
data3=data2(:,index);
test_data=reshape(data3,PointRetenus*size_data,1);
test_number=PointRetenus;

saveHdf5database(file_output,train_data,train_y,train_number,test_data,test_y,test_number,seed)

