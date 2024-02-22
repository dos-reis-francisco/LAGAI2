% ProjectionStawberrySkin.m
% Dos Reis F.
% 19.03.2023


function AchievalMechanicalModules=ProjectionStrawberrySkin(RequestedMechanicalModules)
    % Récupération des données des peaux de fraises
    disp("récupération des données");

    load("skinMatrix.mat","TPOINTS1","TSEGMENTS1","TFACES1","TPOINTS2","TSEGMENTS2","TFACES2",...
        "moyenne1","moyenne2","ecartType1","ecartType2","scaleNuage");
%     load('RawDatas.mat','train_data', 'train_y');
% 
%     disp("génération des deux peaux de fraise a partir des données brouillon");
%     TNUAGE1=train_y([1,2,5],:);
%     TNUAGE2=train_y([2,3,4],:);
%     % normalisation des données train_y
%     [TNUAGE1n,moyenne1,ecartType1]=NormalizeDatas(TNUAGE1);
%     [TNUAGE2n,moyenne2,ecartType2]=NormalizeDatas(TNUAGE2);
%     scaleNuage=100; % homothétie du nuage pour faciliter la visu
%     
%     TNUAGE1n=scaleNuage*TNUAGE1n';
%     TNUAGE2n=scaleNuage*TNUAGE2n';

    % Normalisation du vecteur demandé 
    VectorD1=[RequestedMechanicalModules(1),RequestedMechanicalModules(2),RequestedMechanicalModules(5)];
    VectorD2=[RequestedMechanicalModules(2),RequestedMechanicalModules(3),RequestedMechanicalModules(4)];

    VectorD1_nt=VectorD1-moyenne1';
    VectorD1_n=(VectorD1_nt./ecartType1');
    VectorD1_n=VectorD1_n*scaleNuage;
     
    VectorD2_nt=VectorD2-moyenne2';
    VectorD2_n=(VectorD2_nt./ecartType2');
    VectorD2_n=VectorD2_n*scaleNuage;


%     % Affichage des peaux de fraise
%     fineness=2;
%     [TPOINTS1,TSEGMENTS1,TFACES1]=skin(TNUAGE1n,fineness);
%     f1=drawskin(TPOINTS1,TSEGMENTS1,TFACES1,TNUAGE1n,"Ex", "Ey", "rho",moyenne1,ecartType1);
%     [TPOINTS2,TSEGMENTS2,TFACES2]=skin(TNUAGE2n,fineness);
%     f2=drawskin(TPOINTS2,TSEGMENTS2,TFACES2,TNUAGE2n,"Ey", "Gxy", "nuxy",moyenne2,ecartType2);

    % first skin : % [Ex, Ey, rho] 
    PIntersection1=ProjectionSkin(VectorD1_n,TPOINTS1,TSEGMENTS1,TFACES1);

%     figure(f1);
%     plot3(PIntersection1(1),PIntersection1(2),PIntersection1(3),'*','Color','r','MarkerSize',10);

    % second skin : [Ey, Gxy, nuxy]
    PIntersection2=ProjectionSkin(VectorD2_n,TPOINTS2,TSEGMENTS2,TFACES2);

%     figure(f2);
%     plot3(PIntersection2(1),PIntersection2(2),PIntersection2(3),'*','Color','r','MarkerSize',10);
    
    Ex_n=PIntersection1(1);
    Ey_n=PIntersection1(2);
    Gxy_n=PIntersection2(2);
    nuxy_n=PIntersection2(3);
    rhov_n=PIntersection1(3);

    [Ex,Ey,Gxy,nuxy,rhov]=orgValues(Ex_n,Ey_n,Gxy_n,nuxy_n,rhov_n,moyenne1,...
        ecartType1,moyenne2,ecartType2,scaleNuage);

    AchievalMechanicalModules=[Ex,Ey,Gxy,nuxy,rhov];
end 