%=============================================================
clear;
format compact; format shorte;

N0=1;
N1=129;
%=============================================================
% reading rww

dir = 'rww-line/';
casename='roughWavyWall';
nu=1/4780;
c0=[casename,'.his'];

u0='ave.dat';
u1='upl.dat';

C =dlmread([dir,c0],' ',[N0 0 N1 2]); % X,Y,Z
U1=dlmread([dir,u0],'' ,[N0 1 N1 4]); % vx,vy,vz,pr
U2=dlmread([dir,u1],'' ,[N0 1 N1 3]); % uplus,yplus

xI=C (:,1);
yI=C (:,2);
zI=C (:,3);
uI=U1(:,1);
vI=U1(:,2);
wI=U1(:,3);
pI=U1(:,4);

upI=U2(:,1);
ypI=U2(:,2);
TmI=U2(:,3);

TmI=TmI(1);                 % shear magnitude
utauI=sqrt(TmI/1.0);        % friction velocity
del=0.5;                      % half height
Re_tauI=utauI*del/nu;

t1='tk1.dat';
t2='tk2.dat';
t3='tk3.dat';

tkI=dlmread([dir,'var.dat'],'',[N0 1 N1 3]); % < u' * u' >
cnI=dlmread([dir,'cn1.dat'],'',[N0 1 N1 3]); % convective term
prI=dlmread([dir,'pr1.dat'],'',[N0 1 N1 3]); % production
ptI=dlmread([dir,'pt1.dat'],'',[N0 1 N1 3]); % pressure transport
pdI=dlmread([dir,'pd1.dat'],'',[N0 1 N1 3]); % pressure diffusion
psI=dlmread([dir,'ps1.dat'],'',[N0 1 N1 3]); % pressure strain
tdI=dlmread([dir,'td1.dat'],'',[N0 1 N1 3]); % turbulent diffusion
epI=dlmread([dir,'ep1.dat'],'',[N0 1 N1 3]); % dissipation
vdI=dlmread([dir,'vd1.dat'],'',[N0 1 N1 3]); % viscous diffusion

cnKI=dlmread([dir,t1],'',[N0 1 N1 1]);
prKI=dlmread([dir,t1],'',[N0 2 N1 2]);
ptKI=dlmread([dir,t1],'',[N0 3 N1 3]);
pdKI=dlmread([dir,t1],'',[N0 4 N1 4]);
psKI=dlmread([dir,t2],'',[N0 1 N1 1]);
tdKI=dlmread([dir,t2],'',[N0 2 N1 2]);
epKI=dlmread([dir,t2],'',[N0 3 N1 3]);
vdKI=dlmread([dir,t2],'',[N0 4 N1 4]);
tkKI=dlmread([dir,t3],'',[N0 1 N1 1]);
imKI=dlmread([dir,t3],'',[N0 2 N1 2]);

imI = -cnI + prI + ptI + tdI + epI + vdI;

%=============================================================
% reading rww homogenized

dir = 'rww-hom/';
casename='roughWavyWall';
nu=1/4780;
c0=[casename,'.his'];

u0='ave.dat';
u1='upl.dat';

C =dlmread([dir,c0],' ',[N0 0 N1 2]); % X,Y,Z
U1=dlmread([dir,u0],'' ,[N0 1 N1 4]); % vx,vy,vz,pr
U2=dlmread([dir,u1],'' ,[N0 1 N1 3]); % uplus,yplus

xH=C (:,1);
yH=C (:,2);
zH=C (:,3);
uH=U1(:,1);
vH=U1(:,2);
wH=U1(:,3);
pH=U1(:,4);

upH=U2(:,1);
ypH=U2(:,2);
TmH=U2(:,3);

TmH=TmH(1);                 % shear magnitude
utauH=sqrt(TmH/1.0);        % friction velocity
del=0.5;                      % half height
Re_tauH=utauH*del/nu;

t1='tk1.dat';
t2='tk2.dat';
t3='tk3.dat';

tkH=dlmread([dir,'var.dat'],'',[N0 1 N1 3]); % < u' * u' >
cnH=dlmread([dir,'cn1.dat'],'',[N0 1 N1 3]); % convective term
prH=dlmread([dir,'pr1.dat'],'',[N0 1 N1 3]); % production
ptH=dlmread([dir,'pt1.dat'],'',[N0 1 N1 3]); % pressure transport
pdH=dlmread([dir,'pd1.dat'],'',[N0 1 N1 3]); % pressure diffusion
psH=dlmread([dir,'ps1.dat'],'',[N0 1 N1 3]); % pressure strain
tdH=dlmread([dir,'td1.dat'],'',[N0 1 N1 3]); % turbulent diffusion
epH=dlmread([dir,'ep1.dat'],'',[N0 1 N1 3]); % dissipation
vdH=dlmread([dir,'vd1.dat'],'',[N0 1 N1 3]); % viscous diffusion

cnKH=dlmread([dir,t1],'',[N0 1 N1 1]);
prKH=dlmread([dir,t1],'',[N0 2 N1 2]);
ptKH=dlmread([dir,t1],'',[N0 3 N1 3]);
pdKH=dlmread([dir,t1],'',[N0 4 N1 4]);
psKH=dlmread([dir,t2],'',[N0 1 N1 1]);
tdKH=dlmread([dir,t2],'',[N0 2 N1 2]);
epKH=dlmread([dir,t2],'',[N0 3 N1 3]);
vdKH=dlmread([dir,t2],'',[N0 4 N1 4]);
tkKH=dlmread([dir,t3],'',[N0 1 N1 1]);
imKH=dlmread([dir,t3],'',[N0 2 N1 2]);

imH = -cnH + prH + ptH + tdH + epH + vdH;

%=============================================================
% plotting
cname='line';
n=length(yI);
I=1:5:n;
t = ['Smooth Wavy Wall $$\mathrm{Re}_\tau=$$',num2str(Re_tauI)];

srs  = 1 / utauI ^2;
sb   = 1 /(utauI ^4/nu);

%=============================================================
if(1)
ttl = ['Turbulent Kinetic Energy Budgets'];
%------------------------------
figure; fig=gcf; ax=gca; ax.FontSize=14;
ax.XScale='linear'; ax.YScale='linear';
lgd=legend('location','northeast');lgd.FontSize=10;
hold on; grid on; axis square;

title(ttl,'fontsize',14);
xlabel('$$\frac{\bar{y}/H}{\nu/u_\tau}$$');
%ylabel('$$\frac{\dot{\eta_{ij}}}{u_\tau^4/\nu}$$');
ylabel('$$\dot{\eta_{ij}}$$');

plot(ypI(I),cnKI(I),'mo' ,'linewidth',1.00,'displayname','convection');
plot(ypI(I),prKI(I),'ro' ,'linewidth',1.00,'displayname','production');
plot(ypI(I),pdKI(I),'go' ,'linewidth',1.00,'displayname','pres diff');
plot(ypI(I),tdKI(I),'co' ,'linewidth',1.00,'displayname','turb diff');
plot(ypI(I),vdKI(I),'ko' ,'linewidth',1.00,'displayname','visc diff');
plot(ypI(I),epKI(I),'bo' ,'linewidth',1.00,'displayname','dissipation');
%
plot(ypH,cnKH,'m-','linewidth',2.00,'displayname','Hom convection');
plot(ypH,prKH,'r-','linewidth',2.00,'displayname','Hom production');
plot(ypH,pdKH,'g-','linewidth',2.00,'displayname','Hom pres diff');
plot(ypH,tdKH,'c-','linewidth',2.00,'displayname','Hom turb diff');
plot(ypH,vdKH,'k-','linewidth',2.00,'displayname','Hom visc diff');
plot(ypH,epKH,'b-','linewidth',2.00,'displayname','Hom dissipation');
%------------------------------
figname=[cname,'-','rww-tke-budgets-hom'];
saveas(fig,figname,'jpeg');
end
%=============================================================
