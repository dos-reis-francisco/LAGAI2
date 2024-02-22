% firstNonZero.m
function n=firstNonZero(TFACESCopie)
    nSize=size(TFACESCopie,1);
    n=0;
    for i=1:nSize
        if (TFACESCopie(i)~=0)
            n=i;
            return
        end
    end
    disp("Erreur : recherche de faces absentes");
end