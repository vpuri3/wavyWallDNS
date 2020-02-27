%
% create 2D, ExE, N+1th order SEM grid
%
% constituents:
%	- elements
%	- element interface lines
%	- boundary interface lines

E=2;
N=8;

[z,~] = semmesh(E,N,0);
[x,y] = ndgrid(z);

x=reshape(x,[(N*E)^2,1]);
y=reshape(y,[(N*E)^2,1]);

plot(x,y,'ko');
