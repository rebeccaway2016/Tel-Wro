%%%%%%FUNCTION DESCRIPTION
%This file is designed to test plotting ellipses
%It is meant for envisioning what an image or path will look like
%%%%%%%%%%%%%%%%%%%%%%%%%

%copied the math from https://www.mathworks.com/matlabcentral/answers/86615-how-to-plot-an-ellipse?requestedDomain=www.mathworks.com

x1 = -50;
y1 = 0;
x2 = 50;
y2 = 0;
e = .9;

%center
cx = 0;
cy = 0;
%axis lengths
al = 25;
bl = 10;

a = 1/2*sqrt((x2-x1)^2+(y2-y1)^2);
b = a*sqrt(1-e^2);
t = linspace(0,2*pi);
X = a*cos(t);
Y = b*sin(t);
w = atan2(y2-y1,x2-x1);
x = (x1+x2)/2 + X*cos(w) - Y*sin(w);
y = (y1+y2)/2 + X*sin(w) + Y*cos(w);

%rotated equations
rx = cx + (al*cos(t));
ry = cy + (bl*cos(t));

new_x = x;
new_y = y;


%rotate (not transform-dependent)
for m = 1:numel(x)
%         if any(m == Breaks)
%             f = randi(360);
%         end 
    f = 25;
    new_x(m) = x(m)*cos(f) - x(m)*sin(f);
    new_y(m) = y(m)*cos(f) + y(m)*sin(f);
end



%plot(x,y,new_x,new_y, '--')
plot(x,y,rx,ry,'--')
axis equal