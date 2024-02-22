% randSecondFace.m
% 27.01.2023
% Dos Reis F.
% Fonction qui renvoie un point aléatoire sur le profil de 
% section d'un nuage donné, avec la troisième coordonnée imposée

% premier skin : % [Ex, Ey, rho] 
% second skin : [Ey, Gxy, nuxy]

% [Ex_n, rho_n]

function [Ex, rho]=randSecondFace(Ey_n,TPOINTS,TSEGMENTS,TFACES)
    % calcul des coordonnées d'un vecteur avec une direction aléatoire 
    % avec une origine sur le plan  situé sur un 
    % balayage du nuage avec RayTriangle
    
    nfaces=size(TFACES,1);
    
    found=0;
    ntry=1;
    while (found==0) 
        angle=2*pi*rand();
        vecteurD=[cos(angle) 0 sin(angle)];
        PointO=[0, Ey_n, 0];
        for i=1:nfaces
            [Point1, Point2, Point3]=extractPoint(i,TPOINTS,TSEGMENTS,TFACES);
            [InTriangle, PIntersection]=RayTriangle(Point1, Point2, Point3,...
            PointO,vecteurD);
            if (InTriangle)
                vectorProj=PIntersection-PointO;
                cosVectPint=vectorProj*vecteurD';
                if (cosVectPint>0)
                    found=1;
                    break;
                end
            end
        end

        if (found==0) 
            % point non trouve sur le premier nuage 
            % on relance le calcul avec une nouvelle direction aléatoire 
            % et en se rapprochant du point d'origine
            ntry=ntry+1;
            Ey_n=0.9*Ey_n;
        end
    end
    Ex=PIntersection(1);
    rho=PIntersection(3);
end 