% IsInsideDatasHdf5.m
% filename : file hdf5
% nameData : name of the Data in hdf5
% A : matrix (1,5), datas [Ex, Ey, Gxy, nuxy, rho]
% f : logical 1 if inside, 0 else
% P : if f==1 --> A, if f==0 --> Closed data to A

function [f,P]=IsInsideDatasHdf5(filename,nameData,A)
    A1=A([1,2,3]);
    A2=A([2,4,5]);
    train_y_lin=h5read(filename,nameData);    % datas linearized
    number_datas=length(train_y_lin)/5;
    train_y=zeros(5,number_datas);
    for i=1:number_datas
        train_y(:,i)=train_y_lin((i-1)*5+1:i*5);
    end
    Cloud1=train_y([1,2,3],:)';
    Cloud2=train_y([2,4,5],:)';
    [f1,P1]=IsInsideCloud(A1,Cloud1);
    [f2,P2]=IsInsideCloud(A2,Cloud2);
    f=f1&&f2;
    P=zeros(1,5);
    P([1,2,3])=P1;
    P([2,4,5])=P2;
end