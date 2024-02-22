%% Save_matrix2.m
% append file 
% save a matrix in csv format delimiter ','
% firt line contain rows, columns, dense or band, type (float or int), kl, ku
% Dos Reis F.
% 02.2021
function SaveDenseIntMatrix(file,matrix)
    str=string(size(matrix));
    str(3)='dense';
    str(4)='int';
    str(5)=0;
    str(6)=0;
    writematrix(str,file,'Delimiter',',','WriteMode','overwrite');
    writematrix(matrix,file,'Delimiter',',','WriteMode','append');
end