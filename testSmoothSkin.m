% testSmoothSkin.m

% Point3D p4(2, 2, -2);
% Point3D p5(-2, 2, 2);
% Point3D p6(0, 1, 0);

p4=[2;2;-2];
p5=[-2;2;2];
p6=[0;1;0];
% Circle3D circle(p4, p5, p6);
[circleCenter,circleradius]=Circle3D(p4,p5,p6);
radius1 = circleradius * 2;
radius2 = circleradius / 2;
p7 = SmoothSkin(p4, p5, p6, radius1);
% 
% EXPECT_FALSE(p7 == p6);
if (~IsEqual(p7,p6))
    "Good"
else
    "Bad"
end
p8 = SmoothSkin(p4, p5, p6, radius2);
% 
% EXPECT_TRUE(p8 == p6);
% 

if (IsEqual(p8,p6))
    "Good"
else
    "Bad"
end
% Point3D p9(0, 6, 0);

p9=[0;6;0];
p10 = SmoothSkin(p4, p5, p9, radius1);
% 
% EXPECT_TRUE(p10 == p9);
if (IsEqual(p10,p9))
    "Good"
else
    "Bad"
end