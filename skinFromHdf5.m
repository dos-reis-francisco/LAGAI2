% skinFromHdf5
% draw a skin from y datas in hdf5 file
function skinFromHdf5(filename,namedata,fineness)
%% Read datas from hdf5
train_y_lin=h5read(filename,namedata);    % datas linearized
number_datas=length(train_y_lin)/5;
train_y=zeros(5,number_datas);
for i=1:number_datas
    train_y(:,i)=train_y_lin((i-1)*5+1:i*5);
end
%% génération des deux peaux de fraise
% premier skin : [Ex, Ey, rho] 
% second skin : [Ey, Gxy, nuxy] avec une
disp("generating strawberryskin from y datas");
TNUAGE1=train_y([1,2,5],:);
TNUAGE2=train_y([2,3,4],:);
% normalisation des données train_y
[TNUAGE1n,moyenne1,ecartType1]=NormalizeDatas(TNUAGE1);
[TNUAGE2n,moyenne2,ecartType2]=NormalizeDatas(TNUAGE2);
scaleNuage=100; % homothétie du nuage pour faciliter la visu

TNUAGE1n=scaleNuage*TNUAGE1n';
TNUAGE2n=scaleNuage*TNUAGE2n';

%TNUAGE1n=100*normalize(train_y([1 3 4],:)');

[TPOINTS1,TSEGMENTS1,TFACES1]=skin(TNUAGE1n,fineness);
drawskin(TPOINTS1,TSEGMENTS1,TFACES1,TNUAGE1n,"Ex","Ey","rho",moyenne1,ecartType1);
[TPOINTS2,TSEGMENTS2,TFACES2]=skin(TNUAGE2n,fineness);
drawskin(TPOINTS2,TSEGMENTS2,TFACES2,TNUAGE2n,"Ey","Gxy","nuxy",moyenne2,ecartType2);
% sauvegarde des matrices du skin 
save("skinMatrix","TPOINTS1","TSEGMENTS1","TFACES1","TPOINTS2","TSEGMENTS2",...
    "TFACES2","moyenne1","moyenne2","ecartType1","ecartType2","scaleNuage");
end