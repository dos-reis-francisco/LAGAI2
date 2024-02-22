% PEEL.m
% Dos Reis F. 
% 16.12.2022

function [PEEL_CLOUD,index]=PEEL(TPOINTS,TSEGMENTS,TNUAGE)

    %% 1. je m'impose un rayon moyen : Rmoy=moyenne des longueurs des segments 
    
    nsegments=size(TSEGMENTS,1);
    npoints=size(TNUAGE,1);
    nsommets=size(TPOINTS,1);

    P1=TPOINTS(TSEGMENTS(:,1),:);
    P2=TPOINTS(TSEGMENTS(:,2),:);
    seg=P2-P1;
    seg2=seg.^2;
    A=[1;1;1];
    seg3=seg2*A;
    seg4=sqrt(seg3);
    Rmoy=mean(seg4);

    %% 2. je fait un premier balayage de tous les sommets :
    % (a) calcul des distance de tous les points du nuage au point en cours 
    % (b) je garde les points dont la distance est inférieure à Rmoy 
    % (c) je sauvegarde le nombre de points gardés par sommet i: n_{keep}^{i}
    % (d) j'élimine du nuage les points gardés
    pActuel=1;
    nkeep=zeros(nsommets,1);
    TNUAGE1=TNUAGE;
    for i=1:nsommets
        P1=TPOINTS(i,:);
        A=ones(npoints,3);
        B=[A(:,1)*P1(1) A(:,2)*P1(2) A(:,3)*P1(3)];
        seg=TNUAGE1-B;
        seg2=seg.^2;
        C=[1;1;1];
        seg3=seg2*C;
        seg4=sqrt(seg3);
        seg5=seg4<(Rmoy/2);
        keep1=find(seg5);   % indice des valeurs à 1
        nkeep(i,1)=size(keep1,1);
        PEEL_CLOUD1(pActuel:(pActuel+nkeep(i,1)-1),:)=TNUAGE1(keep1,:);
        TNUAGE1(keep1,:)=zeros(nkeep(i,1),3);
        pActuel=pActuel+nkeep(i,1);
    end
    %% 3. Affichage valeur moyenne \overline{x} et écart type 
    % \sigma de n_{keep}^{i}: analyse de l'écart type (facultatif ?) : 
    % (a) si la moyenne est petite (<10 ?) ou bien si le rapport 
    % écart type/moyenne s'il est trop grand (\dfrac{\sigma}{\overline{x}}<\dfrac{1}{3})
    % –> il faut augmenter Rmoy et recommencer le point (2)
    % l'écart apparit comme très important
    meanNkeep=mean(nkeep);
    ecart=std(nkeep);
    %% 4. second balayage similaire à 2., mais je ne conserve que 
    % nc=(\overline{x}-\sigma/2) soit environ 30% des points au total des 
    % points calculés. Si le nombre np de points dont la distance est 
    % inférieure à Rmoy est > nc –> je choisis au hasard nc points conservés 
    % TODO : mettre a jour documentation
    nc=ceil(0.25*meanNkeep);
    if (nc==0)
        print("erreur dans sélection du nombre moyen de points");
        return;
    end
    pActuel=1;
    nkeep=zeros(nsommets,1);
    TNUAGE2=TNUAGE;
    PEEL_CLOUD2=zeros(npoints,3);
    index2=zeros(npoints,1);
    for i=1:nsommets
        P1=TPOINTS(i,:);
        A=ones(npoints,3);
        B=[A(:,1)*P1(1) A(:,2)*P1(2) A(:,3)*P1(3)];
        seg=TNUAGE2-B;
        seg2=seg.^2;
        C=[1;1;1];
        seg3=seg2*C;
        seg4=sqrt(seg3);
        seg5=seg4<(Rmoy/2);
        keep1=find(seg5);   % indice des valeurs à 1
        if (keep1==0)
            break;
        end
        nkeep(i,1)=size(keep1,1);
        if (nkeep(i,1)<=nc) 
            PEEL_CLOUD2(pActuel:(pActuel+nkeep(i,1)-1),:)=TNUAGE2(keep1,:);
            TNUAGE2(keep1,:)=zeros(nkeep(i,1),3);
            index2(pActuel:(pActuel+nkeep(i,1)-1),1)=keep1;
            pActuel=pActuel+nkeep(i,1);
        else
            nkeep(i,1)=nc;
            PEEL_CLOUD2(pActuel:(pActuel+nc-1),:)=TNUAGE2(keep1(1:nc),:);
            TNUAGE2(keep1(1:nc),:)=zeros(nc,3);
            index2(pActuel:(pActuel+nc-1),1)=keep1(1:nc);
            pActuel=pActuel+nc;
        end
    end
PEEL_CLOUD=PEEL_CLOUD2(1:(pActuel-1),:);
index=index2(1:(pActuel-1));
end