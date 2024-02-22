% SurfaceTriangle.m

function surface=SurfaceTriangle(Point1,Point2,Point3)
vec1=Point2-Point1;
vec2=Point3-Point1;
surface=1/2*norm(cross(vec1',vec2'));
end