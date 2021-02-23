function [EEbar]=plotEEbarindv(TableImp,ymax,method)

B1=mode(TableImp.B1);      %Import B1   

EETable=TableImp(:,{'Phase','EnergieMpHist'});   
EETable.EEvert=[sum(EETable.EnergieMpHist(:,1:B1),2), sum(EETable.EnergieMpHist(:,B1+1:end),2)];
EEsum=groupsummary(EETable,{'Phase'},method);  % summe oder mittelwert?
log=string(EEsum.Phase)=="Gesamt" | string(EEsum.Phase)=="Gesamte Einheit";
EEsum(log,:)=[];
EEsum=removevars(EEsum,{'GroupCount'});
EEsum.Properties.VariableNames={'Phase','Histo','Vert'};

EEbar=figure('visible','off');
ba=bar(EEsum.Vert,'stacked','FaceColor','flat');
    title(gca,'Energie pro Viertel');
    legend('aerob','anaerob','Location','northeast')
    xLabel=EEsum.Phase;    
    set(gca,'xticklabel',xLabel)
    ylabel('Energie [kcal]') 
    ax = gca;
    ax.YGrid = 'on';
if ymax>1000
    set(gca,'YTick',[0:250:10000]);
    ylim([0 ymax]);

else
    if height(unique(TableImp(:,4)))>1
        title(gca,'Ø Teamenergie pro Viertel');
        set (gca,'YTick',[0:25:600]);
        ylim([0 ymax]);
    else 
        title(gca,'Individuelle Energie pro Viertel');
        set (gca,'YTick',[0:25:600]);
        ylim([0 ymax]);
    end
end

    
     
        
% set(gcf,'units','centimeter','position',[5,2,30,20])
ba(1).CData = [1 1 0];
%ba(2).CData = [1 .5 0];

ae=EEsum.Vert(:,1);
an=EEsum.Vert(:,2);
pae=ae/2;
pan=ae+an/2;

xt=get(gca,'XTick');
for c=1:length(ae)
text(xt(c), pae(c), num2str(ae(c),'%0.0f'),'FontWeight','bold','FontSize',12,...
    'HorizontalAlignment','center','VerticalAlignment','middle')
end

for c=1:length(an)
text(xt(c), pan(c), num2str(an(c),'%0.0f'),'FontWeight','bold','FontSize',12,...
    'HorizontalAlignment','center','VerticalAlignment','middle')
end

    ax=gca;
    ax.FontSize= 8;
end