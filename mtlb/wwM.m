clear

visc = 1/4780;
dsty = 1;
delta=0.5; % half height

[xyzS,velS,varS,uplS,budS] = wwRead('smoothWavyWall','../data/swwMesh/');
[xyzR,velR,varR,uplR,budR] = wwRead('roughWavyWall' ,'../data/rwwMesh/');

budgets = ["Convection", "Production", "Pressure Transport", "Pressure Diffusion"...
          ,"Pressure Strain", "Turbulent Diffusion", "Dissipation", "Viscous Diffusion"...
          ,"Imbalance"];
bb = ["cn", "pr", "pt", "pd", "ps", "td", "ep", "vd", "im"];

cc = ["r","g","b","c","m","y","k"];

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
if(0) % surface pressure
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
title(['Surface Stress Profiles'],'fontsize',14)
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$\tau_w $$');
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
if(1) % surface skin friction
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
title(['Surface Stress Profiles'],'fontsize',14)
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$\frac{2\tau_w}{\rho U^2}$$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

plot(xyzS(1,:,1),2*uplS(1,:,3),'r-','linewidth',1.50,'displayname','SWW');
plot(xyzR(1,:,1),2*uplR(1,:,3),'b-','linewidth',1.50,'displayname','RWW');

plot(xwS,0.1*(ywS-max(ywS)),'k--'  ,'linewidth',1.50,'displayname','SWW');
plot(xwR,0.1*(ywR-max(ywR)),'k--'  ,'linewidth',1.50,'displayname','RWW');
%------------------------------
figname=['skin','-','friction'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % friction velocity
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
title(['Surface Stress Profiles'],'fontsize',14)
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$u_f$$');
%lgd
lgd=legend('location','northwest');lgd.FontSize=14;

plot(xyzS(1,:,1),uplS(1,:,4),'r-','linewidth',1.50,'displayname','SWW');
plot(xyzR(1,:,1),uplR(1,:,4),'b-','linewidth',1.50,'displayname','RWW');

plot(xwS,0.1*(ywS-max(ywS)),'k--'  ,'linewidth',1.50,'displayname','SWW');
plot(xwR,0.1*(ywR-max(ywR)),'k--'  ,'linewidth',1.50,'displayname','RWW');
%------------------------------
figname=['friction','-','vel'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(0) % Yplus values
%------------------------------
figure;
fig=gcf;ax=gca;
hold on;grid on;
% title
title(['$$y^+$$ values'],'fontsize',14)
% ax
ax.XScale='linear';ax.YScale='linear';ax.FontSize=14;
xlim([0,1]);
xlabel('$$x/\lambda$$');
ylabel('$$y^+$$');
%lgd=legend('location','northwest');lgd.FontSize=14;

% (ny,nx,N)
for npt = 2:lx1;
cci = convertStringsToChars(cc(npt-1));
plot(xyzS(npt,:,1),uplS(npt,:,2),[cci,'-'] ,'linewidth',1.50,'displayname',['SWW point ',num2str(npt)]);
plot(xyzR(npt,:,1),uplR(npt,:,2),[cci,'--'],'linewidth',1.50,'displayname',['RWW point ',num2str(npt)]);
end

plot(xwS,10*(ywS-max(ywS)),'k--','linewidth',1.50,'displayname','SWW');
plot(xwR,10*(ywR-max(ywR)),'k--','linewidth',1.50,'displayname','RWW');
%------------------------------
figname=['yplus'];
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
if(0)
bplt(x,y,tkK,tk(:,:,1),tk(:,:,2),tk(:,:,3),Tmavg,visc,cname,'Reynolds Stresses','rs');
end
%=============================================================
if(1) % scalar fields
for i=1:9
    bbi      = convertStringsToChars(bb(i));
    budgetsi = convertStringsToChars(budgets(i));
    cplt(xyzS(:,:,1),xyzS(:,:,2),xwS,ywS,budS(:,:,4,1),1,'sww'...
             ,[budgetsi,' K'],[bbi,'K'],'$$\eta$$');
    cplt(xyzR(:,:,1),xyzR(:,:,2),xwR,ywR,budR(:,:,4,1),1,'rww'...
             ,[budgetsi,' K'],[bbi,'K'],'$$\eta$$');
end
%=============================================================
end
