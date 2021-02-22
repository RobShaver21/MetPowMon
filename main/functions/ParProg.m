function [img]=ParProg(T1,T2,date,a)

y=T2{:,a+1};
x=T2{:,1};

y2=T1{1,a};
x2=date;

img=figure;%('visible','on');
hold on

scatter(x,y,'db','filled','LineWidth',3)
plot(x,y,'b','LineWidth',1)
scatter(x2,y2,'dr','filled','LineWidth',3)
ax = gca;
ax.XGrid = 'on';

ix=find(hour(x)==0);                      
getTick=ax.XTick;
ax.XTick=ax.XTick(1):days(1):ax.XTick(end);                   
       

%xlabel=datestr(x,'dd.mm HH:MM');
%xticklabels(xlabel);ix=find(hour(t)==0);                        % indices for first of month in time vector
xtickangle(45)

set(gcf,'units','centimeter','position',[10,10,30,10])

mw=mean(y);
sd=std(y)*0.5;
b1=min(y);
b2=max(y);
scale=(b2-b1)*0.5;

ylim([b1-scale b2+scale]);
yline(mw,'--r')
yline(mw+sd,':r')
yline(mw-sd,':r')

ylabel(T1.Properties.VariableNames{:,a},'FontSize',12);

set(gca, 'FontSize',10)
