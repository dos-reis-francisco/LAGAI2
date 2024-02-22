% ClosedDatasHdf5.m
% filename : file hdf5
% nameData : name of the Data in hdf5
% A : matrix (1,5), datas [Ex, Ey, Gxy, nuxy, rho]
% P : Closed data to A
% index : index of the data in the hdf5 file

function [P,index]=ClosedDatasHdf5(filename,nameData,A)
    train_y_lin=h5read(filename,nameData);    % datas linearized
    number_datas=length(train_y_lin)/5;
    train_y=zeros(5,number_datas);
    for i=1:number_datas
        train_y(:,i)=train_y_lin((i-1)*5+1:i*5);
    end
    [train_y_normalized,mean_data,std_dev]=NormalizeDatas(train_y);
    A_normalized=(A'-mean_data)./std_dev;
    temp1=train_y_normalized-A_normalized;
    temp2=temp1.^2;
    temp3=sum(temp2,1);
    [val,index]=min(temp3);
    P=train_y(:,index);
end