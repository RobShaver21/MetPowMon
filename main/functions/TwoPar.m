function [img]=TwoPar(ExTableTeam)

x=categorical(ExTableTeam{:,1});
y1=ExTableTeam{:,2};
y2=ExTableTeam{:,3};

y1Lab=ExTableTeam.Properties.VariableNames{2};
y2Lab=ExTableTeam.Properties.VariableNames{3};

y1=y1-1;  

mwy1=mean(y1);
mwy2=mean(y2);
sc1=std(y1)*0.5;
sc2=std(y2)*0.5;

figure;

yyaxis left
    hold on
    plot(x(1:end-1),y1(1:end-1),'-*')
    plot(x(end),y1(end),'*','HandleVisibility','off')

    YL=get(gca,'ylim');
    YL=[YL(1) YL(2)+YL(2)-YL(1)];
    set(gca,'ylim',YL)
    
    yline(mwy1,'--b','HandleVisibility','off')
    yline(mwy1+sc1,':b','HandleVisibility','off')
    yline(mwy1-sc1,':b','HandleVisibility','off')
    
%     ylabel(y1Lab)

yyaxis right
    plot(x(1:end-1),y2(1:end-1),'-*')
    plot(x(end),y2(end),'*','HandleVisibility','off')

    YL=get(gca,'ylim');
    YL=[YL(1)-(YL(2)-YL(1)) YL(2)];
    set(gca,'ylim',YL)

    yline(mwy2,'--r','HandleVisibility','off')
    yline(mwy2+sc2,':r','HandleVisibility','off')
    yline(mwy2-sc2,':r','HandleVisibility','off')
    
%     ylabel(y2Lab)
    xtickangle(0);
    ax=gca;
    ax.FontSize= 9;
    title(gca,'Ø Team-Verlauf EDI & AI','FontSize',10);
    legend(y1Lab,y2Lab);
    box on;
    img=gcf;

