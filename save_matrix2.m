%% Save_matrix2.m
% append file 
% save a matrix in csv format delimiter ','
% firt line contain rows, columns, dense or band, type (float or int), kl, ku
% Dos Reis F.
% 02.2021
function save_matrix2(file,matrix,name)
    writematrix(name,file,'WriteMode','append');
    writematrix(size(matrix),file,'WriteMode','append');
    writematrix(matrix,file,'Delimiter',',','WriteMode','append');
end