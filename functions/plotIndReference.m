function [RefPlot]=plotIndReference(ZIndTeam,ZInd,index)

% if-Schleife für NaN-Werte
% Index need to be adjusted
Name=unique([ZInd.Name]);
log=ZInd.Name==string (Name(index));
ZIndS=ZInd(log,:);

log=ZIndTeam.Name==string (Name(index));
ZIndTeamS=ZIndTeam(log,:);

log=string(ZIndS.Phase)=="Gesamte Einheit";
Zind=ZIndS(log,:);
Zind=removevars(Zind,{'Phase','Name','Dauer'});

RefPlot=figure;
% ('visible','on');

if height(Zind)>0
    log=string(ZIndTeamS.Phase)=="Gesamte Einheit";
    Zindteam=ZIndTeamS(log,:);
    Zindteam=removevars(Zindteam,{'Phase','Name','Dauer'}); 
    Z=[Zind{:,:}' Zindteam{:,:}'];
    

    if ~isnan(Z(1,1))
        p=bar(Z);
        title(gca,'Vergleich Team / Individuell');
        yline(0.3,':r')
        yline(-0.3,':r')
        % legend('Individueller Längsschnitt','Querschnitt zum Team','Location','north');
        legend([p(1) p(2)],'Individuell','Team','Location','north','FontSize',6)
    else
        p=bar(Zindteam{:,:});
        %p=bar(Z{:,:})
        title(gca,'Platzhalter'); 
    end
    
else
    log=string(ZIndTeamS.Phase)=="Gesamt";
    Zindteam=ZIndTeamS(log,:);
    Zindteam=removevars(Zindteam,{'Phase','Name','Dauer'});
    p=bar(Zindteam{:,:});
    Z=Zindteam{:,:};
    %p=bar(Z{:,:})
    title(gca,'Platzhalter');
    set(gca,'xticklabel',Zindteam.Properties.VariableNames,'FontSize',8);
end

        ylabel('Differenz [SD] zum Durchschnitt','FontSize',8);
        set(gca,'xticklabel',Zindteam.Properties.VariableNames,'FontSize',8);
        ax = gca;
        xtickangle(45);
        ax.YGrid = 'on';
        m=max(max(abs(Z)))*120;
        m=ceil(m/10)*10;
        % set(gca,'YTick',[-m:10:m]);
        % ylim([-m m]);
        
%         ax = ancestor(p, 'axes');
%         yrule = ax.YAxis;
%         xrule = ax.XAxis;
%         % yrule.FontSize = 10;
%         xrule.FontSize=8;
%         RefPlot=gcf;
        
           
set(gcf,'units','centimeter','position',[10,10,15,7.5])
 

