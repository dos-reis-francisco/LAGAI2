%testRayTriangle.m

Point1=[0, 0, 1];
Point2=[2, 0, 0];
Point3=[0,2,0];
vecteur=[1, 1, 1];

[InTriangle, PIntersection]=RayTriangle(Point1, Point2, Point3,vecteur)

Point1=[0, 0, 1];
Point2=[1, 0, 0];
Point3=[0,1,0];
vecteur=[-1, 1, 1];

[InTriangle, PIntersection]=RayTriangle(Point1, Point2, Point3,vecteur)