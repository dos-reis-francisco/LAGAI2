% SurfaceFace.m
% 23.01.2023
% Dos Reis F.

function surface=SurfaceFace(i,TPOINTS,TSEGMENTS,TFACES)

seg1=TFACES(i,1);
seg2=TFACES(i,2);
P1=TSEGMENTS(seg1,1);
P2=TSEGMENTS(seg1,2);
P3=TSEGMENTS(seg2,1);
if ((P3==P1) || (P3==P2))
    P3=TSEGMENTS(seg2,2);
end
Point1=TPOINTS(P1,:);
Point2=TPOINTS(P2,:);
Point3=TPOINTS(P3,:);
surface=SurfaceTriangle(Point1,Point2,Point3);