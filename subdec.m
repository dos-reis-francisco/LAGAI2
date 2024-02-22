%subdec.m
% Dos Reis F.
% 29.12.2022

function subdec(file_input,file_output,train_number,test_number,seed)
    size_data=(seed*2+4)*(seed*2+4)*12;
    li=(seed*2+4);
    co=(seed*2+4);
    la=12;
    
    [train_data,train_y]=readHdf5database(file_input,"/train_data","/train_y",train_number,seed);

    for i=1:train_number
        base=(i-1)*size_data+1;
        mat_lin=train_data(base:(base+size_data-1));
        Mat3D=linear_to_3D(mat_lin,seed);
        [dx,dy,li1,co1]=firstNN(Mat3D,li,co);
        Mat=subNN(Mat3D,dx,dy,li1,co1,li,co);
        Mat1D=linearShape(Mat,li,co,la);
        train_data(base:(base+size_data-1))=Mat1D;
    end
    [test_data,test_y]=readHdf5database(file_input,"/test_data","/test_y",test_number,seed);
    for i=1:test_number
        base=(i-1)*size_data+1;
        mat_lin=test_data(base:(base+size_data-1));
        Mat3D=linear_to_3D(mat_lin,seed);
        [dx,dy,li1,co1]=firstNN(Mat3D,li,co);
        Mat=subNN(Mat3D,dx,dy,li1,co1,li,co);
        Mat1D=linearShape(Mat,li,co,la);
        test_data(base:(base+size_data-1))=Mat1D;
    end
    saveHdf5database(file_output,train_data,train_y,train_number,...
    test_data,test_y,test_number,seed)
end

function [alpha,beta,li1,co1]=firstNN(Mat3D,li,co)
    li1=0;co1=0;
    alpha=0;beta=0;
    for i=1:li
        for j=1:co
            alpha=Mat3D(i,j,1);
            if (alpha~=0)
                beta=Mat3D(i,j,2);
                li1=i;co1=j;
                return;
            end
        end
    end
end

function Mat=subNN(Mat3D,dx,dy,li1,co1,li,co)
    Mat=Mat3D;
    for i=li1:li
        for j=1:co
            a=Mat3D(i,j,1);
            if (a~=0)
                Mat(i,j,1)=(a-dx+0.5);
                Mat(i,j,2)=(Mat3D(i,j,2)-dy+0.5);
            end
        end
    end
end