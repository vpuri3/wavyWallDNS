clear

visc = 1/4780;
dsty = 1;
delta=0.5; % half height

[xyzS,velS,varS,uplS,budS] = wwRead('smoothWavyWall','../data/swwMesh/');
[xyzR,velR,varR,uplR,budR] = wwRead('roughWavyWall' ,'../data/rwwMesh/');

%=============================================================
% mesh, geometry
%=============================================================
if(1)

xlen=4;
lx1=8;
nelxS=64;  nelyS=16;
nelxR=128; nelyR=24;

xmeshS = 0.5*(1+semmesh(nelxS,lx1,0))*xlen; % \in [0,1]
ymeshS = 0.5*(1+semmesh(nelyS,lx1,1));
nxmeshS=length(xmeshS);
nymeshS=length(ymeshS);
xmeshS = ones(nymeshS,1)*xmeshS';
ymeshS = ymeshS*ones(1,nxmeshS);

xmeshR = 0.5*(1+semmesh(nelxR,lx1,0))*xlen; % \in [0,1]
ymeshR = 0.5*(1+semmesh(nelyR,lx1,1));
nxmeshR=length(xmeshR);
nymeshR=length(ymeshR);
xmeshR = ones(nymeshR,1)*xmeshR';
ymeshR = ymeshR*ones(1,nxmeshR);

[xmeshS,ymeshS,xwS,ywS] = wavyWall(xmeshS,ymeshS,'smoothWavyWall');
[xmeshR,ymeshR,xwR,ywR] = wavyWall(xmeshR,ymeshR,'roughWavyWall');

end

%=============================================================
if(1) % mesh
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
% title
title(['Smooth Wavy Wall',' Mesh'],'fontsize',14);
% pos
daspect([1,1,1]);
% ax
ax.FontSize=14;
xlabel('$$x$$');
ylabel('$$y$$');
xlim([min(min(xmeshS)),max(max(xmeshS))]);
ylim([min(min(ymeshS)),max(max(ymeshS))]);

mesh(xmeshS,ymeshS,0*xmeshS)
% color
colormap([0,0,0])
%------------------------------
figname=['sww','-','mesh'];
saveas(fig,figname,'jpeg');
%==============================
%==============================
figure;
fig=gcf;ax=gca;
hold on;grid on;
title(['Rough Wavy Wall',' Mesh'],'fontsize',14);
daspect([1,1,1]);
ax.FontSize=14;
xlabel('$$x$$');
ylabel('$$y$$');
xlim([min(min(xmeshR)),max(max(xmeshR))]);
ylim([min(min(ymeshR)),max(max(ymeshR))]);

mesh(xmeshR,ymeshR,0*xmeshR)
% color
colormap([0,0,0])
%------------------------------
figname=['rww','-','mesh'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % surface pressure
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
title(['Surface Pressure Profiles'],'fontsize',14)
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$\frac{p-p_\mathrm{ref}}{\rho U^2}$$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

% (ny,nx,N)
plot(xyzS(1,:,1),velS(1,:,4)-min(velS(1,:,4)),'r-','linewidth',1.50,'displayname','SWW');
plot(xyzR(1,:,1),velR(1,:,4)-min(velR(1,:,4)),'b-','linewidth',1.50,'displayname','RWW');

plot(xwS,ywS-max(ywS),'k--'  ,'linewidth',1.50,'displayname','SWW');
plot(xwR,ywR-max(ywR),'k--'  ,'linewidth',1.50,'displayname','RWW');
%------------------------------
figname=['surface','-','pressure'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % surface shear stress
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
% title
title(['Surface Stress Profiles'],'fontsize',14)
% pos
set(fig,'position',[585,1e3,1000,500])
% ax
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$\rho $$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

plot(xyzS(1,:,1),uplS(1,:,3),'r-','linewidth',1.50,'displayname','SWW');
plot(xyzR(1,:,1),uplR(1,:,3),'b-','linewidth',1.50,'displayname','RWW');

plot(xwS,0.1*(ywS-max(ywS)),'k--'  ,'linewidth',1.50,'displayname','SWW');
plot(xwR,0.1*(ywR-max(ywR)),'k--'  ,'linewidth',1.50,'displayname','RWW');
%------------------------------
figname=['surface','-','stress'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % first point off the wall stats
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
% title
title(['Distance of first point off the wall'],'fontsize',14)
% ax
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$y/H$$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

% (ny,nx,N)
d2fS = xyzS(2,:,2) - xyzS(1,:,2);
d2fR = xyzR(2,:,2) - xyzR(1,:,2);

plot(xyzS(1,:,1),d2fS,'r-','linewidth',1.50,'displayname','SWW');
plot(xyzR(1,:,1),d2fR,'b-','linewidth',1.50,'displayname','RWW');

%------------------------------
figname=['yplus','-','first_point_distance'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % first point off the wall stats
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
% title
title(['$$y^+$$ of first point off the wall'],'fontsize',14)
% ax
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$y^+$$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

% (ny,nx,N)
npt = 1;
plot(xyzS(npt,:,1),uplS(npt,:,2),'r-','linewidth',1.50,'displayname','SWW');
plot(xyzR(npt,:,1),uplR(npt,:,2),'b-','linewidth',1.50,'displayname','RWW');

%------------------------------
figname=['yplus','-','p1'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(0) % attachment/reattachment point
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
% title
title([casename,' $$v_x$$ at first point off the wall '],'fontsize',14)
%daspect([1,2,1]);
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$ u $$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

plot(x(2,:),u(2,:),'b-','linewidth',1.50,'displayname','$$u$$ right off the wall');
plot(xw,yw-max(yw),'k--'  ,'linewidth',1.50,'displayname','Bottom Wall');
%------------------------------
figname=[cname,'-','separation'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(0) % RS, TK Budgets
%-------------------------------------------------------------
bplt(x,y,tkK,tk(:,:,1),tk(:,:,2),tk(:,:,3),Tmavg,visc,cname,'Reynolds Stresses','rs');
%bplt(x,y,cnK,cn(:,:,1),cn(:,:,2),cn(:,:,3),Tmavg,visc,cname,'Convection','cn');
bplt(x,y,prK,pr(:,:,1),pr(:,:,2),pr(:,:,3),Tmavg,visc,cname,'Production','pr');
%bplt(x,y,ptK,pt(:,:,1),pt(:,:,2),pt(:,:,3),Tmavg,visc,cname,'Pressure Transport','pt');
%bplt(x,y,tdK,td(:,:,1),td(:,:,2),td(:,:,3),Tmavg,visc,cname,'Turbulent Diffusion','td');
%bplt(x,y,vdK,vd(:,:,1),vd(:,:,2),vd(:,:,3),Tmavg,visc,cname,'Viscous Diffusion','vd');
%bplt(x,y,epK,ep(:,:,1),ep(:,:,2),ep(:,:,3),Tmavg,visc,cname,'Dissipation','ep');
bplt(x,y,imK,im(:,:,1),im(:,:,2),im(:,:,3),Tmavg,visc,cname,'Imbalance','im');
%-------------------------------------------------------------
end
%=============================================================
%bplt(x,y,cnK,cn(:,:,1),cn(:,:,2),cn(:,:,3),Tmavg,visc,cname,'Convection Hom','cnH');
%bplt(x,y,epK,ep(:,:,1),ep(:,:,2),ep(:,:,3),Tmavg,visc,cname,'Dissipation Hom','epH');
%=============================================================
if(0) % scalar fields
%-------------------------------------------------------------
cplt(x,y,xw,yw,pr(:,:,1),1,cname,'Dissipation','ep11','$$\epsilon_{11}$$');
cplt(x,y,xw,yw,pr(:,:,2),1,cname,'Dissipation','ep22','$$\epsilon_{11}$$');
cplt(x,y,xw,yw,pr(:,:,3),1,cname,'Dissipation','ep33','$$\epsilon_{11}$$');
%=============================================================
end
%-------------------------------------------------------------
if(0) % line plots
%------------------------------
ixx    =[1 ceil(0.5*nx)             ceil(0.7*nx)];
ixxmesh=[1 (1+(nelx/4*0.5)*(lx1-1)) 0           ];

% scale
s = 1/Tmavg; % RS
s = 1/(Tmavg*Tmavg/visc);

for i=1:length(ixx)
	ix    =ixx(i);
	ixmesh=ixxmesh(i);

	strx = num2str(x(1,ix));
	ymw  = (y(:,ix)-y(1,ix)) / (1-y(1,ix));
	ymsh = 0.5*(1+semmesh(nely,lx1,1));

	figure;
	fig=gcf;ax=gca;
	hold on;grid on;
	% title
	title([casename,' TKE Budgets at $$x/\lambda$$=',strx],'fontsize',14);
	% ax
	ax.FontSize=14;
	xlabel('$$\bar{y}/H$$');
	ylabel('$$\frac{\dot{\eta_{ij}}}{u_\tau^4/\nu}$$');
	%lgd
	lgd=legend('location','southeast');lgd.FontSize=12;
	
	plot(ymw,cnK(:,ix)*s,'-','linewidth' ,1.50,'DisplayName',['Convection'])
	plot(ymw,prK(:,ix)*s,'-','linewidth' ,1.50,'DisplayName',['Production'])
	plot(ymw,ptK(:,ix)*s,'-','linewidth' ,1.50,'DisplayName',['Pres Transp'])
	plot(ymw,tdK(:,ix)*s,'-','linewidth' ,1.50,'DisplayName',['Turbulent Diff'])
	plot(ymw,vdK(:,ix)*s,'-','linewidth' ,1.50,'DisplayName',['Viscous Diff'])
	plot(ymw,epK(:,ix)*s,'-','linewidth' ,1.50,'DisplayName',['Dissipation'])
	plot(ymw,imK(:,ix)*s,'k-','linewidth',1.50,'DisplayName',['Imbalance'])
	% mesh
	plot(ymsh,0*ymsh,'kx','linewidth',1.00,'DisplayName',['Mesh'])

	xlim([0,0.3]);
	%------------------------------
	figname=[cname,'-','tke-budgets-x=',strx];
	saveas(fig,figname,'jpeg');
	%------------------------------
end

end
%=============================================================
