clear

visc = 1/4780;
dsty = 1;
delta=0.5; % half height

[xyzS,velS,varS,uplS,budS] = wwRead('smoothWavyWall','../data/swwLine/');
[xyzR,velR,varR,uplR,budR] = wwRead('roughWavyWall' ,'../data/rwwLine/');

budgets = ["Convection", "Production", "Pressure Transport", "Pressure Diffusion"...
          ,"Pressure Strain", "Turbulent Diffusion", "Dissipation", "Viscous Diffusion"...
          ,"Imbalance"];
bb = ["cn", "pr", "pt", "pd", "ps", "td", "ep", "vd", "im"];

cc = ["r","g","b","c","m","y","k","r"];
vv = ["11","22","33"];

ufS = uplS(1,1,4);
ufR = uplR(1,1,4);
RetauS = delta * ufS / visc;
RetauR = delta * ufR / visc;

srsS = ufS * ufS;
srsR = ufR * ufR;

srbS = ufS^4 / visc;
srbR = ufR^4 / visc;

%=============================================================

yS = xyzS(:,1,2); ySn = yS - yS(1);
yR = xyzS(:,1,2); yRn = yR - yR(1);

%=============================================================
if(1) % vel
figure; fig=gcf; ax=gca; ax.FontSize=14;
ax.XScale='linear'; ax.YScale='linear';
lgd=legend('location','northwest');lgd.FontSize=10;
hold on; grid on; axis square;

title('Mean Streamwise Velocity','fontsize',14);
xlabel('$$\bar{y}/H$$');
ylabel('$$u^+$$');

plot(ySn,velS(:,:,1) / ufS,'r-','linewidth',1.50,'displayname','SWW');
plot(yRn,velR(:,:,1) / ufR,'b-','linewidth',1.50,'displayname','RWW');

figname=['line','-','vel'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % reynolds stresses
figure; fig=gcf; ax=gca; ax.FontSize=14;
ax.XScale='linear'; ax.YScale='linear';
lgd=legend('location','northeast');lgd.FontSize=10;
hold on; grid on; axis square;

title('Reynolds Stresses','fontsize',14);
xlabel('$$\bar{y}/H$$');
ylabel('$$\frac{\eta_{ij}}{u_{\tau^2}}$$');

for i=1:3
    cci = convertStringsToChars(cc(i));
    vvi = convertStringsToChars(vv(i));
    plot(ySn,varS(:,:,i) / srsS,[cci,'-' ],'linewidth',1.50,'displayname',['SWW ',vvi]);
    plot(yRn,varR(:,:,i) / srsR,[cci,'--'],'linewidth',1.50,'displayname',['RWW ',vvi]);
end

plot(ySn,varS(:,:,5) / srsS,'k-' ,'linewidth',1.50,'displayname','SWW TKE');
plot(yRn,varR(:,:,5) / srsR,'k--','linewidth',1.50,'displayname','RWW TKE');

figname=['line','-','rs'];
saveas(fig,figname,'jpeg');
end
%=============================================================
if(1) % budgets
figure; fig=gcf; ax=gca; ax.FontSize=14;
ax.XScale='linear'; ax.YScale='linear';
lgd=legend('location','northeast');lgd.FontSize=10;
hold on; grid on; axis square;

title('TKE Budgets','fontsize',14);
xlabel('$$\bar{y}/H$$');
ylabel('$$\frac{\dot{\eta_{ij}}}{u_\tau^4/\nu}$$');

for i=1:8
    cci = convertStringsToChars(cc(i));
    bbi = convertStringsToChars(bb(i));
    plot(ySn,budS(:,:,4,i) / srbS,[cci,'-' ],'linewidth',1.50,'displayname',['SWW ',bbi,' K']);
    plot(yRn,budR(:,:,4,i) / srbR,[cci,'--'],'linewidth',1.50,'displayname',['RWW ',bbi,' K']);
end

figname=['line','-','bud'];
saveas(fig,figname,'jpeg');
end
%=============================================================
