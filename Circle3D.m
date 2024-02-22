% Circle3D.m
% Circle3D::Circle3D(Point3D P1, Point3D P2, Point3D P3)
function [Center,radiusCircle]=Circle3D(Pt1,Pt2,Pt3)
% 
% {
% 	if (P1 == P2 || P1 == P3 || P2 == P3)
% 	{
% 		info = -1;
% 		return;
% 	}
if (IsEqual(Pt1,Pt2)||IsEqual(Pt1,Pt3)||IsEqual(Pt2,Pt3))
    Center=[0;0;0];
    radiusCircle=0;
    return;
end
% 	P=Plane(P1, P2, P3);
V1=Vector3D(Pt1,Pt2);
V2=Vector3D(Pt1,Pt3);
if (size(V1)==size(V2))
normal=cross(V1,V2);
else
    "Error"
end
normal=normal/norm(normal);
% 	// find midpoints of two lines joining the three points
% 	Point3D mp12 = Point3D((P1.X + P2.X) / 2.0, (P1.Y + P2.Y) / 2.0, 
% 		(P1.Z + P2.Z) / 2.0);
mp12=(Pt1+Pt2)/2.0;
% 	Point3D mp23 = Point3D((P1.X + P3.X) / 2.0, (P1.Y + P3.Y) / 2.0, (P1.Z + P3.Z) / 2.0);
mp23=(Pt1+Pt3)/2.0;
% 	// find normal vectors to the two lines, which are also normal vectors to the plane of the circle
% 	Vector3D norm12 = Vector3D(P1,P2).Normalize();
% 	Vector3D norm23 = Vector3D(P1,P3).Normalize();
norm12=V1/norm(V1);
norm23=V2/norm(V2);
% 	if (norm12.CrossProduct(norm23) == Vector3D(0, 0, 0))
% 	{
% 		info = -1;
% 		return;
% 	}
V3=cross(norm12,norm23);
if (norm(V3)==0)
    Center=[0;0;0];
    radiusCircle=0;
    return;
end
% 	info=0;
% 	Vector3D perp1=norm12.CrossProduct(P.Normal);
% 	Vector3D perp2=norm23.CrossProduct(P.Normal);
perp1=cross(norm12,normal);
perp2=cross(norm23,normal);

% 	// find the intersection of the two lines
% 	Line3D L1=Line3D(mp12,perp1);
% 	Line3D L2=Line3D(mp23,perp2);
mp12b=mp12+perp1;
mp23b=mp23+perp2;

% 	Center=L1.Intersection(L2);
Center=Intersection(mp12,mp12b,mp23,mp23b);

% 	radius=Vector3D(Center,P1).Length();
radiusCircle=norm(Center-Pt1);
% 	// find the radius as the distance between the center and one of the input points
% 	Center2DProjection();
% }
end