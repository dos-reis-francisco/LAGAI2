% Point3D Line3D::Intersection(Line3D S)
function Center=Intersection(mp12,mp12b,mp23,mp23b)
% double p1x = P1.X;
% 	double p1y = P1.Y;
% 	double p1z = P1.Z;
p1x=mp12(1);
p1y=mp12(2);
p1z=mp12(3);
% 	double p2x = P2.X;
% 	double p2y = P2.Y;
% 	double p2z = P2.Z;
p2x=mp12b(1);
p2y=mp12b(2);
p2z=mp12b(3);
% 	double p3x = S.P1.X;
% 	double p3y = S.P1.Y;
% 	double p3z = S.P1.Z;
p3x=mp23(1);
p3y=mp23(2);
p3z=mp23(3);
% 	double p4x = S.P2.X;
% 	double p4y = S.P2.Y;
% 	double p4z = S.P2.Z;
p4x=mp23b(1);
p4y=mp23b(2);
p4z=mp23b(3);

t1 = (p1x * p3y - p1x * p4y - p1y * p3x + p1y * p4x + p3x * p4y - p3y * p4x)/...
		(p1x * p3y - p1x * p4y - p1y * p3x + p1y * p4x - p2x * p3y + p2x * p4y + p2y * p3x - p2y * p4x);
t2 = -(p1x * p2y - p1x * p3y - p1y * p2x + p1y * p3x + p2x * p3y - p2y * p3x)/ ...
		(p1x * p3y - p1x * p4y - p1y * p3x + p1y * p4x - p2x * p3y + p2x * p4y + p2y * p3x - p2y * p4x);

% 
% 		Point3D P;
% 		P.X = p1x + t1 * (p2x - p1x);
% 		P.Y = p1y + t1 * (p2y - p1y);
% 		P.Z = p1z + t1 * (p2z - p1z);
Center(1)=p1x + t1 * (p2x - p1x);
Center(2)=p1y + t1 * (p2y - p1y);
Center(3)=p1z + t1 * (p2z - p1z);
% 		double PZ2 = p3z + t2 * (p4z - p3z);
PZ2 = p3z + t2 * (p4z - p3z);
% 		if (P.Z != PZ2) {
% 			info = -1;
% 			return Point3D(0, 0, 0);
% 		}
% 		else
% 		{
% 			info = 0;
% 			return P;
% 		}
if (PZ2~=Center(3))
    Center=[0;0;0];
end
end