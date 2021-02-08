    
% i=300
% Orient = Fission(i).Orient;
% s      = Fission(i).s;
% 
% k1  = tan(Orient(1).Orientation);
% xy1 = [s(1).Centroid];
% k2  = tan(Orient(2).Orientation);
% xy2 = [s(2).Centroid];
% 


function Degree = intersection_lines(k1,xy1,k2,xy2)


x1 = [ xy1(1) 0 2000 -2000];
y1 = [ xy1(2)  [-xy1(1)]*k1+[xy1(2)] [2000-xy1(1)]*k1+[xy1(2)] [-2000-xy1(1)]*k1+[xy1(2)]];

x2 = [ xy2(1) 0 2000 -2000];
y2 = [ xy2(2)  [-xy2(1)]*k2+[xy2(2)] [2000-xy2(1)]*k2+[xy2(2)] [-2000-xy2(1)]*k2+[xy2(2)]];

[xi,yi] = polyxpoly(x1,y1,x2,y2);

% figure; hold on;
%  plot(x1,y1);
%  plot(x2,y2);
%  plot(xy1(1),xy1(2),'r+');
%  plot(xy2(1),xy2(2),'r+');
%  plot(xi(1),yi(2),'bo');
% 
% mapshow(xi,yi,'DisplayType','point','Marker','o')

u1 = [ x1(1)-xi(1) y1(1)-yi(1) ];

u2 = [ x2(1)-xi(1) y2(1)-yi(1) ];

CosTheta = dot(u1,u2)/norm(u1)/norm(u2);

Degree = acosd(CosTheta);



 

end

