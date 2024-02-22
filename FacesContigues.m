% FacesContigues.m
% 27.01.2023
% Dos Reis F.
% Donne la liste des nouvelles faces contigues à une liste fournie et 
% auquel on retranche les faces déjà traitées

function [TFACESENCOURS,balayageFini]=FacesContigues(TFACESENCOURS, ...
    TSEGMENTS1, TFACES1, TFACESTRAITEES)
    nfaces=size(TFACES1,1);

    % élimine les faces déjà traitées
    TFACESCopie=TFACES1;
    n=sizeNonZero(TFACESTRAITEES);
    if (n==nfaces)
        balayageFini=true;
        index=nfaces*rand();
        TFACESENCOURS(1)=index;
        return
    else
        balayageFini=false;

        TFACESCopie(TFACESTRAITEES(1:n),:)=0;

        newTFACESENCOURS=zeros(nfaces,1);
        indexNew=1;
        % analyse de faces en cours jusqu'à rencontrer zéro
        nT=sizeNonZero(TFACESENCOURS);
        for i=1:nT
            face=TFACESENCOURS(i);
            if(face==0)
                break;
            end
            % pour chaque face récupération des numéros des segments de la face
            % recherche des faces contigues
            % sauvegarde des nouvelles faces et élimination des faces déjà traitées
            listeSegments=TFACES1(face,:);

            [listeFacesContigues,empty,TFACESCopie]=rechercheFace(listeSegments,TFACESCopie);
            if (empty==false)
                nnewFaces=sizeNonZero(listeFacesContigues);
                newTFACESENCOURS(indexNew:(indexNew+nnewFaces-1))=listeFacesContigues(1:nnewFaces);
                indexNew=indexNew+nnewFaces;
                
            end
        end
        if (newTFACESENCOURS(1)==0)
            newTFACESENCOURS(1)=firstNonZero(TFACESCopie);
        end
        TFACESENCOURS=newTFACESENCOURS;

    end
end

function [listeFacesContigues,empty,TFACESCopie]=rechercheFace(listeSegments,TFACESCopie)
    index=1;
    empty=true;
    nfaces=size(TFACESCopie,1);
    listeFacesContigues=zeros(nfaces,1);
    % premier segment
    seg=listeSegments(1);
    liste=findIndex(seg,TFACESCopie);
    if (liste~=0)
        sizeListe=size(liste,2);
        listeFacesContigues(index:(index+sizeListe-1))=liste;
        TFACESCopie(liste,:)=0;
        index=index+sizeListe;
        empty=false;
    end
    % second segment
    seg=listeSegments(2);
    liste=findIndex(seg,TFACESCopie);
    if (liste~=0)
        sizeListe=size(liste,2);
        listeFacesContigues(index:(index+sizeListe-1))=liste;
        TFACESCopie(liste,:)=0;
        index=index+sizeListe;
        empty=false;
    end
    % dernier segment
    seg=listeSegments(3);
    liste=findIndex(seg,TFACESCopie);
    if (liste~=0)
        sizeListe=size(liste,2);
        listeFacesContigues(index:(index+sizeListe-1))=liste;
        TFACESCopie(liste,:)=0;
        index=index+sizeListe;
        empty=false;
    end
end
