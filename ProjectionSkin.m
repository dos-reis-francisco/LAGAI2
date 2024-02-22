% ProjectionSkin.m
% 19.03.2023
% Dos Reis F.
% Fonction qui renvoie un point  sur un nuage donné
% d'après un vecteur fourni

function PIntersection=ProjectionSkin(VectorD,TPOINTS,TSEGMENTS,TFACES)
    % calcul des coordonnées du vecteur 
    % avec une origine sur le plan  situé sur un 
    % balayage du nuage avec RayTriangle
    
    nfaces=size(TFACES,1);
    
    found=0;
    while (found==0) 
        PointO=[0, 0, 0];
        for i=1:nfaces
            [Point1, Point2, Point3]=extractPoint(i,TPOINTS,TSEGMENTS,TFACES);
            [InTriangle, PIntersection]=RayTriangle(Point1, Point2, Point3,...
            PointO,VectorD);
            if (InTriangle)
                cosVectInter=PIntersection*VectorD';
                if (cosVectInter>0)
                    found=1;
                    break;
                end
            end
        end
    end
end 