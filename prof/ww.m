%=============================================================
clear;
format compact; format shorte;

%=============================================================
% reading SWW
casename='smoothWavyWall';
nx = 10;
ny = 100;

N0=1;
N1=nx*ny;

dir = 'sww-h/';
c0  = [dir,casename,'.his'];
u0  = [dir,'ave.dat'];
tk  = [dir,'var.dat'];
co  = [dir,'cov.dat'];
t1  = [dir,'tk1.dat'];
t2  = [dir,'tk2.dat'];
t3  = [dir,'tk3.dat'];

C =dlmread(c0,' ',[N0 0 N1 2]); % X,Y,Z
U1=dlmread(u0,'' ,[N0 1 N1 4]); % vx,vy,vz,pr
tk=dlmread(tk,'' ,[N0 1 N1 4]); % <uu>,<vv>,<ww>,<pp>
co=dlmread(co,'' ,[N0 1 N1 4]); % <uv>,<vw>,<wu>,<p>

prKS=dlmread(t1,'',[N0 2 N1 2]);
tkKS=dlmread(t3,'',[N0 1 N1 1]);

xS=C (:,1);
yS=C (:,2);
zS=C (:,3);
uS=U1(:,1);
vS=U1(:,2);
wS=U1(:,3);
pS=U1(:,4);

uuS=tk(:,1);
vvS=tk(:,2);
wwS=tk(:,3);
ppS=tk(:,3);
uvS=co(:,1);
vwS=co(:,2);
wuS=co(:,3);

xS=reshape(xS,[ny,nx]);
yS=reshape(yS,[ny,nx]);
zS=reshape(zS,[ny,nx]);
uS=reshape(uS,[ny,nx]);
vS=reshape(vS,[ny,nx]);
wS=reshape(wS,[ny,nx]);
pS=reshape(pS,[ny,nx]);

uuS=reshape(uuS,[ny,nx]);
vvS=reshape(vvS,[ny,nx]);
wwS=reshape(wwS,[ny,nx]);
ppS=reshape(ppS,[ny,nx]);
uvS=reshape(uvS,[ny,nx]);
vwS=reshape(vwS,[ny,nx]);
wuS=reshape(wuS,[ny,nx]);

prKS=reshape(prKS,[ny,nx]);
tkKS=reshape(tkKS,[ny,nx]);

xS  = xS - 2;

%=============================================================
% reading RWW
casename='roughWavyWall';
nx = 10;
ny = 100;

N0=1;
N1=nx*ny;

dir = 'rww/';
c0  = [dir,casename,'.his'];
u0  = [dir,'ave.dat'];
tk  = [dir,'var.dat'];
co  = [dir,'cov.dat'];
t1  = [dir,'tk1.dat'];
t2  = [dir,'tk2.dat'];
t3  = [dir,'tk3.dat'];

C =dlmread(c0,' ',[N0 0 N1 2]); % X,Y,Z
U1=dlmread(u0,'' ,[N0 1 N1 4]); % vx,vy,vz,pr
tk=dlmread(tk,'' ,[N0 1 N1 4]); % <uu>,<vv>,<ww>,<pp>
co=dlmread(co,'' ,[N0 1 N1 4]); % <uv>,<vw>,<wu>,<p>

prKR=dlmread(t1,'',[N0 2 N1 2]);
tkKR=dlmread(t3,'',[N0 1 N1 1]);

xR=C (:,1);
yR=C (:,2);
zR=C (:,3);
uR=U1(:,1);
vR=U1(:,2);
wR=U1(:,3);
pR=U1(:,4);

uuR=tk(:,1);
vvR=tk(:,2);
wwR=tk(:,3);
ppR=tk(:,3);
uvR=co(:,1);
vwR=co(:,2);
wuR=co(:,3);

xR=reshape(xR,[ny,nx]);
yR=reshape(yR,[ny,nx]);
zR=reshape(zR,[ny,nx]);
uR=reshape(uR,[ny,nx]);
vR=reshape(vR,[ny,nx]);
wR=reshape(wR,[ny,nx]);
pR=reshape(pR,[ny,nx]);

uuR=reshape(uuR,[ny,nx]);
vvR=reshape(vvR,[ny,nx]);
wwR=reshape(wwR,[ny,nx]);
ppR=reshape(ppR,[ny,nx]);
uvR=reshape(uvR,[ny,nx]);
vwR=reshape(vwR,[ny,nx]);
wuR=reshape(wuR,[ny,nx]);

prKR=reshape(prKR,[ny,nx]);
tkKR=reshape(tkKR,[ny,nx]);

xR  = xR - 2;

%=============================================================
% bottom wall

x = linspace(0,1,100);
y = 0*x;

[x,y,xsw,ysw] = wavyWall(x,y,'smoothWavyWall');
[x,y,xrw,yrw] = wavyWall(x,y,'roughWavyWall');

%=============================================================
prof(xsw,ysw,xrw,yrw,xS,yS,uS ,xR,yR,uR,0.08,'u','Streamwise Velocity');
%prof(xsw,ysw,xrw,yrw,xS,yS,uuS,xR,yR,uuR,1,'uu','$$\eta_{11}$$');
prof(xsw,ysw,xrw,yrw,xS,yS,-uvS,xR,yR,-uvR,2,'uv','$$-\eta_{12}$$');
%prof(xsw,ysw,xrw,yrw,xS,yS,prKS,xR,yR,prKR,0.2,'prK','TKE Production');
%=============================================================

