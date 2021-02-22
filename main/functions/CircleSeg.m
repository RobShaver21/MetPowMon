function CircleSeg(a,b,X,Y,R)
% a,b: Start/end of arc in radians
% X,Y: center of circle
% R: radius

th = linspace(a, b);
x = R*cos(th) + X;
y = R*sin(th) + Y;
plot(x,y,'k'); axis equal;

end