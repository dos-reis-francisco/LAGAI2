% RayTriangle.m
% Dos Reis F.
% 10.01.2023
% basé sur l'algorithme de [mollerFastMinimumStorage1997] qui va renvoyer :
 

function [InTriangle, PIntersection]=RayTriangle(Point1, Point2, Point3,...
    PointO,vecteurD)
% Point 1, 2 et 3 : points définissant le triangle dans l'espace
% PointO : point origine du rayon
% vecteurD : vecteur de direction du rayon partant de PointO
% InTriangle : une valeur booléenne indiquant True ou False, 
% si le vecteur rencontre le triangle 
% PIntersection : point d'intersection du triangle et du vecteur 
    norm_vecteur=sqrt(vecteurD(1)*vecteurD(1)+vecteurD(2)*vecteurD(2)+...
        vecteurD(3)*vecteurD(3));
    D=vecteurD/norm_vecteur;
    E1=Point2-Point1;
    E2=Point3-Point1;
    T=PointO-Point1;
    P=cross(D,E2);
    Q=cross(T,E1);
    Mat=[Q*E2';P*T'; Q*D'];
    result=(1/(P*E1'))*Mat;
    u=result(2);v=result(3);
    if ((u<0) || (v<0) || (u+v)>1)
        InTriangle=false;
    else
        InTriangle=true;
    end
    PIntersection=result(1)*D+PointO;
end

