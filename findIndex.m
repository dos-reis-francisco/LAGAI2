% findIndex.m
% Dos Reis F.
% 10.02.2023
% trouve la liste des index dans le tableau 
% contenant la valeur seg

function liste=findIndex(seg,TFACESCopie)
    nSize=size(TFACESCopie,1);
    liste=0;
    for i=1:nSize
        if ((seg==TFACESCopie(i,1)) || (seg==TFACESCopie(i,2)) ...
                || (seg==TFACESCopie(i,3)))
            if liste==0
                liste=i;
            else
                liste=[liste,i];
            end
        end
    end
end