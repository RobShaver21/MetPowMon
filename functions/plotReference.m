function [RefPlot]=plotReference(Zteam)

% log=string(Zteam.Phase)=="Gesamte Einheit";
% Z=Zteam(log,:);
% Z=removevars(Z,{'Phase'});

log=string(Zteam.Phase)=="Gesamte Einheit";
Z=Zteam(log,:);
Z=removevars(Z,{'Phase'});

RefPlot=figure;
%RefPlot=figure;
p=bar(Z{:,:});
%p=bar(Z{:,:})
    title(gca,'Vergleich zur Referenz');
    set(gca,'xticklabel',Z.Properties.VariableNames,'FontSize',8);
    xtickangle(45);
    ylabel('Differenz in std zum Durchschnitt','FontSize',8);
    ax = gca;
    ax.YGrid = 'on';
    %set(gca,'YTick',[-30:10:30]);
    m=max(abs(Z{:,:}));
    %ylim([-30 30]);
    set(gcf,'units','centimeter','position',[10,10,15,7.5])
    yline(0.3,':r')
    yline(-0.3,':r')
 RefPlot=gcf; 


  