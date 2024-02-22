% 
% //[point3] = smoothskin(P1, P2, P3, radius)
% //
% //• renvoie P3 initial si
% //
% //– convexe
% //
% //– concave, mais rayon de courbure du cercle(p1, p2, p3) > radius
% //
% //• sinon recalcule un nouveau p3 concave mais à l'intersection 
% //entre le cercle p1, p2 avec radius donné et la droite (O,P3) 
% 
% Point3D SmoothSkin(Point3D p1, Point3D p2, Point3D p3, double radius)

function [Pt4] = SmoothSkin(Pt1,Pt2,Pt3,radiusMin)
% {
% 	Point3D p;
% 
% 	Circle3D circle(p1, p2, p3);
[Center,radiusCircle]=Circle3D(Pt1,Pt2,Pt3);
% 	if (circle.radius > radius)
% 	{
% 		p = p3;
% 		return p;
% 	}
if radiusCircle>radiusMin

    Pt4=Pt3;

    else
        % 	else
    % 	{
    % 		Point3D O(0, 0, 0);
    % 
    % 		double d1 = O.Distance(p1);
    % 		double d2 = O.Distance(p2);
    % 		double d3 = O.Distance(p3);
    % 
    PtO=[0;0;0];
    d1=distance(Pt1,PtO);
    d2=distance(Pt2,PtO);
    d3=distance(Pt3,PtO);
    % 		if ((d3 > d1) || (d3 > d2))
    if ((d3>d1) ||(d3>d2))

        % 		{
        % 			p = p3;
        % 			return p;
        % 		}
        Pt4=Pt3;
        % 		else {
        % 			double d4 = radius - circle.radius;
        % 			p = p3 + Vector3D(p3, circle.Center).Normalize() * d4;
        % 			return p;
        % 		}
    else
        d4=radiusMin-radiusCircle;
        V=Vector3D(Pt3,Center);
        V=V/norm(V);
        Pt4=Pt3+d4*V;
        % 	}
        % }
    end
end
end