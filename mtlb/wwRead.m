function [xyz,vel,var,upl,bud] = wwRead(casename,dir)

% >> wwPost('smoothWavyWall','./ex1/sww/') 

visc = 1/4780;
dsty = 1;
delta=0.5;      % half height

%--------------------------------------------------
% parsing logfile
%--------------------------------------------------
logfile=textread([dir,'logfile'],'%s','delimiter','\n');
% avgtime
at=find(~cellfun(@isempty,strfind(logfile,'atime:')));
at=logfile(at(end));
at=cell2mat(at);
at=str2num(at(7:end));
% Tmavg - shear force magnitude
Tmavg=find(~cellfun(@isempty,strfind(logfile,'Tmavg:')));
Tmavg=logfile(Tmavg(end));
Tmavg=cell2mat(Tmavg);
Tmavg=str2num(Tmavg(7:end));
% area
area=find(~cellfun(@isempty,strfind(logfile,'area:')));
area=logfile(area(end));
area=cell2mat(area);
area=str2num(area(6:end));
% Ufavg - average friction velocity
ufavg=find(~cellfun(@isempty,strfind(logfile,'Ufavg:')));
ufavg=logfile(ufavg(end));
ufavg=cell2mat(ufavg);
ufavg=str2num(ufavg(7:end));

ufavg=sqrt(Tmavg/dsty);
Re_tau = ufavg*delta/visc;

[casename,' Tmavg, area, ufavg, Re_tau = ',num2str(Tmavg),' ', num2str(area),' ', num2str(ufavg),' ', num2str(Re_tau)]
%--------------------------------------------------
% get history points shape, size

c0=[dir,casename,'.his'];

hh = textread(c0,'%s','delimiter','\n');
hh = hh(1);
hh = cell2mat(hh);
hh = split(hh,' ');
nx = str2num(cell2mat(hh(4)));
ny = str2num(cell2mat(hh(6)));

N0 = 1;
N1 = nx*ny;
%--------------------------------------------------

u0=[dir,'ave.dat'];
u1=[dir,'upl.dat'];

C =dlmread(c0,' ',[N0 0 N1 2]); % X,Y,Z
U1=dlmread(u0,'' ,[N0 1 N1 4]); % vx,vy,vz,pr
U2=dlmread(u1,'' ,[N0 1 N1 3]); % uplus,yplus

at=dlmread(u1,'' ,[1 0 1 0]);
x=C (:,1);
y=C (:,2);
z=C (:,3);
u=U1(:,1);
v=U1(:,2);
w=U1(:,3);
p=U1(:,4);

up=U2(:,1);
yp=U2(:,2);
Tm=U2(:,3);
uf = sqrt(Tm/1.0); % average friction velocity

tk=dlmread([dir,'var.dat'],'',[N0 1 N1 4]); % < u' * u' >

cn=dlmread([dir,'cn1.dat'],'',[N0 1 N1 3]); % convective term
pr=dlmread([dir,'pr1.dat'],'',[N0 1 N1 3]); % production
pt=dlmread([dir,'pt1.dat'],'',[N0 1 N1 3]); % pressure transport
pd=dlmread([dir,'pd1.dat'],'',[N0 1 N1 3]); % pressure diffusion
ps=dlmread([dir,'ps1.dat'],'',[N0 1 N1 3]); % pressure strain
td=dlmread([dir,'td1.dat'],'',[N0 1 N1 3]); % turbulent diffusion
ep=dlmread([dir,'ep1.dat'],'',[N0 1 N1 3]); % dissipation
vd=dlmread([dir,'vd1.dat'],'',[N0 1 N1 3]); % viscous diffusion

% imbalance in reynolds stresse1s
im = - cn + pr + pt + td + ep + vd;

t1=[dir,'tk1.dat'];
t2=[dir,'tk2.dat'];
t3=[dir,'tk3.dat'];

% cnK == 0.5 * sum(cn')';
cnK=dlmread(t1,'',[N0 1 N1 1]);
prK=dlmread(t1,'',[N0 2 N1 2]);
ptK=dlmread(t1,'',[N0 3 N1 3]);
pdK=dlmread(t1,'',[N0 4 N1 4]);
psK=dlmread(t2,'',[N0 1 N1 1]);
tdK=dlmread(t2,'',[N0 2 N1 2]);
epK=dlmread(t2,'',[N0 3 N1 3]);
vdK=dlmread(t2,'',[N0 4 N1 4]);
tkK=dlmread(t3,'',[N0 1 N1 1]);
imK=dlmread(t3,'',[N0 2 N1 2]);
%-------------------------------------------------------------
% reshape
%-------------------------------------------------------------
budgets = [cnK;prK;ptK;tdK;vdK;epK];
budgetsmin = min(budgets);
budgetsmax = max(budgets);
cb=0;
%--------------------
x=reshape(x,[ny,nx]);
y=reshape(y,[ny,nx]);
z=reshape(z,[ny,nx]);
u=reshape(u,[ny,nx]);
v=reshape(v,[ny,nx]);
w=reshape(w,[ny,nx]);
p=reshape(p,[ny,nx]);

uvar=reshape(tk(:,1),[ny,nx]);
vvar=reshape(tk(:,2),[ny,nx]);
wvar=reshape(tk(:,3),[ny,nx]);
pvar=reshape(tk(:,4),[ny,nx]);

up=reshape(up,[ny,nx]);
yp=reshape(yp,[ny,nx]);
Tm=reshape(Tm,[ny,nx]);
uf=reshape(uf,[ny,nx]);

tk=reshape(tk,[ny,nx,4]);

cn=reshape(cn,[ny,nx,3]);
pr=reshape(pr,[ny,nx,3]);
pt=reshape(pt,[ny,nx,3]);
pd=reshape(pd,[ny,nx,3]);
ps=reshape(ps,[ny,nx,3]);
td=reshape(td,[ny,nx,3]);
ep=reshape(ep,[ny,nx,3]);
vd=reshape(vd,[ny,nx,3]);
im=reshape(im,[ny,nx,3]);

cnK=reshape(cnK,[ny,nx]);
prK=reshape(prK,[ny,nx]);
ptK=reshape(ptK,[ny,nx]);
pdK=reshape(pdK,[ny,nx]);
psK=reshape(psK,[ny,nx]);
tdK=reshape(tdK,[ny,nx]);
epK=reshape(epK,[ny,nx]);
vdK=reshape(vdK,[ny,nx]);
tkK=reshape(tkK,[ny,nx]);
imK=reshape(imK,[ny,nx]);

%--------------------------------------
% Assemble output
%--------------------------------------

xyz = zeros(ny,nx,3);
xyz(:,:,1) = x;
xyz(:,:,2) = y;
xyz(:,:,3) = z;

vel = zeros(ny,nx,4);
vel(:,:,1) = u;
vel(:,:,2) = v;
vel(:,:,3) = w;
vel(:,:,4) = p;

var = zeros(ny,nx,5);
var(:,:,1) = uvar;
var(:,:,2) = vvar;
var(:,:,3) = wvar;
var(:,:,4) = pvar;
var(:,:,5) = tkK;

upl = zeros(ny,nx,4);
upl(:,:,1) = up;
upl(:,:,2) = yp;
upl(:,:,3) = Tm;
upl(:,:,4) = uf;

bud = zeros(ny,nx,4,9);
bud(:,:,1:3,1) = cn;
bud(:,:,1:3,2) = pr;
bud(:,:,1:3,3) = pt;
bud(:,:,1:3,4) = pd;
bud(:,:,1:3,5) = ps;
bud(:,:,1:3,6) = td;
bud(:,:,1:3,7) = ep;
bud(:,:,1:3,8) = vd;
bud(:,:,1:3,9) = im;

bud(:,:,4,1) = cnK;
bud(:,:,4,2) = prK;
bud(:,:,4,3) = ptK;
bud(:,:,4,4) = pdK;
bud(:,:,4,5) = psK;
bud(:,:,4,6) = tdK;
bud(:,:,4,7) = epK;
bud(:,:,4,8) = vdK;
bud(:,:,4,9) = imK;

