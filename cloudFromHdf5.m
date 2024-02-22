% skinFromHdf5_2
% draw a skin from y datas in hdf5 file
function cloudFromHdf5(filenameFigure1,filenameFigure2, filenameData,namedata,...
    numberDatas)

%% Read datas from hdf5
train_y_lin=h5read(filenameData,namedata);    % datas linearized
number_datas=length(train_y_lin)/5;
if (number_datas<=numberDatas) 
    train_y=zeros(5,number_datas);
    for i=1:number_datas
        train_y(:,i)=train_y_lin((i-1)*5+1:i*5);
    end
else
    train_y=zeros(5,numberDatas);
    for i=1:numberDatas
        j=ceil(number_datas*rand);
        train_y(:,i)=train_y_lin((j-1)*5+1:j*5);
    end
end

%% génération des deux clouds
% premier cloud : [Ex, Ey, rho] 
% second cloud : [Ex, Gxy, nuxy] avec une
TNUAGE1=train_y([1,2,5],:);
TNUAGE2=train_y([1,3,4],:);

% normalisation des données train_y
[TNUAGE1n,moyenne1,ecartType1]=NormalizeDatas(TNUAGE1);
[TNUAGE2n,moyenne2,ecartType2]=NormalizeDatas(TNUAGE2);
scaleNuage=100; % homothétie du nuage pour faciliter la visu

TNUAGE1n=scaleNuage*TNUAGE1n';
TNUAGE2n=scaleNuage*TNUAGE2n';
AngleCamera=[192 19];
f1=drawCloud2(TNUAGE1n,"Ex","Ey","rho",1,AngleCamera);
savefig(f1,filenameFigure1);
AngleCamera=[141 17];
f2=drawCloud2(TNUAGE2n,"Ex","Gxy","nuxy",2,AngleCamera);
savefig(f2,filenameFigure2);
end