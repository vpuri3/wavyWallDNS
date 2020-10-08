%
% Apply geometric deformation to vectors
% x,y of size (ny,nx) and return
% deformed xd,yd of same size
%
function [xd,yd,xw,yw] = wavyWall(x,y,casename)

xd=x;

d =2.54;
l =20*d;
f =5;

if(strcmp(casename,'smoothWavyWall'))
	d2=0;
elseif(strcmp(casename,'roughWavyWall'))
	d2=0.4*d;
end

xw=x(1,:);
H =max(max(y));

% dimensional
xw=xw*l;
yw=   d *cos(2*pi*xw/l  );
yw=yw+d2*cos(2*pi*xw/l*f);

% nondim
sx=1/l;
xw=xw*sx;
yw=yw*sx;

yd=(1-yw/H).*y+yw;

end
