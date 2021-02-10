function [img]=TeamScatter(Struct,ID)
% ID: 1=Scatter HI, 2=VO2, 3=both

Vector=Struct.SaveStruct.VectorExport;
Einheit=Struct.SaveStruct.Einheit;
Einheit=datetime(Einheit,'InputFormat','yyyyMMdd_HHmmss');
H=timeofday(Einheit);

str=string({Vector.Phase}');
log=strcmp(str,"Gesamte Einheit");
NewSprintExp=Vector(log,:);

S=max([length(NewSprintExp(1).Zeit) length(NewSprintExp(2).Zeit)]);
xLabel=0:5:S/600;

CellSprint=struct2cell(NewSprintExp);
LfdNr=cell2mat(CellSprint(1,:));
Nachname=CellSprint(3,:);

M=CellSprint(5,:);
[mX,mY]=sprintscatter(M,0);

img=figure; % ('visible','on');
hold on

%% Scatter ID=1
if ID==1

    xlim([0 S]);
    ylim([-length(LfdNr)-1 2]);
    
    mY=[mY; ones(length(mX),1)];
    mX=[mX; mX];
    
    yLabel={'','Gesamt',''}';
    yLabel=flip([yLabel; Nachname']);
    
    scatter(mX,mY,'r<')
    
    set(gca,'YTick', -length(LfdNr):2)
    set(gca,'yticklabel',yLabel)
    grid on
    
    title(gca,'Hochintensive Aktionen (MP > 55 W/kg)')
    set(gcf,'units','centimeter','position',[5,2,30,20])
    set(gca,'XTick', 0:5*600:S,'xticklabel',xLabel)
    xlabel('Zeit [min]')
    
%% Heat ID=2
elseif ID==2
    
    for a=1:length(NewSprintExp)
        heat=NewSprintExp(a).VO2t;
        % MP=NewSprintExp(a).MP;
        x=1:length(heat);
        y=zeros(size(x)) - a;
        z=zeros(size(x));
        col=heat';
        
        surface([x;x],[y;y],[z;z],[col;col],...
            'facecol','no','edgecol','interp','linew',27);
    end
    
    sgtitle('$$\dot{V}$$O2 in ml/min/kg','fontweight','bold','interpreter','latex');
    set(gcf,'units','centimeter','position',[5,2,30,20])
    
    set(gca,'XTick', 0:5*600:S,'xticklabel',xLabel)
    xlabel('Zeit [min]')
    
    yLabel=flip(Nachname);
    set(gca,'YTick', -length(LfdNr):-1)
    set(gca,'yticklabel',yLabel)
    ylim([-length(LfdNr)-0.5 -0.5])
    
    colorbar
    colormap(parula);
    
%% combined plot

elseif ID==3

    xlim([0 S]);
    ylim([-length(LfdNr)-1 1]);
    
    % VO2
    for a=1:length(NewSprintExp)
        heat=NewSprintExp(a).VO2t;
        
        d=NewSprintExp(a).Uhr(1);
        d=datetime(d,'InputFormat','HH:mm:ss.SSS');
        d=timeofday(d);
        d=seconds(H-d)*10;
        x=1:length(heat);
        x=x+d;
        
        y=zeros(size(x)) - a;
        z=zeros(size(x));
        col=heat';
        
        surface([x;x],[y;y],[z;z],[col;col],...
            'facecol','no','edgecol','interp','linew',17);
    end
    
    % N-highVO2
    
    I=1:length(NewSprintExp);
    N = 5;
    m = arrayfun(@(x) numel(NewSprintExp(x).VO2t), I );
    m = max(m);
    FillNan= @(x,m) vertcat(x,nan(m-length(x),1));
    
    VO2mat=arrayfun(@(x) ...
        FillNan(NewSprintExp(x).VO2t,m),...
        I,'UniformOutput',false );
    VO2mat=[VO2mat{:}];
    VO2mat(isnan(VO2mat)) = 0;
    VO2mat=sort(VO2mat,2, 'descend');
    
    VO2meanN=mean(VO2mat(:,1:N),2);
    
    % plot N mean VO2
    
    col=VO2meanN';
    x=1:length(col);
    y=zeros(size(x));
    z=zeros(size(x));
    
    surface([x;x],[y;y],[z;z],[col;col],...
        'facecol','no','edgecol','interp','linew',15);
    
    % Scatter
    
    mY=[mY; zeros(length(mX),1)];
    mX=[mX; mX];
    
    yLabel={'';'Gesamt'};
    yLabel=flip([yLabel; Nachname']);
    
    scatter(mX,mY,'k<')
    
    % axes
    set(gca,'YTick', -length(LfdNr):2)
    set(gca,'yticklabel',yLabel)
    
    set(gca,'XTick', 0:5*600:S,'xticklabel',xLabel)
    xlabel('Zeit [min]')
    
    % size & title
    set(gcf,'units','centimeter','position',[5,2,30,20])
    
    sgtitle(...
        {'$$\dot{V}$$O2 in [ml/min/kg]',...
        'Hochintensive Aktionen (MP $>$ 55 W/kg)'},...
        'fontweight','bold',...
        'interpreter','latex');
    
    colorbar
    colormap(flipud(hot));
    caxis([0 65])
    
end
%% Anaerobic Capacity
% if ID==3
% RQ=0.96; kE=18.8+(21.1-18.8)*((RQ-0.7)/0.3);
%
% img=figure ('visible','on')
%
% for a=1:length(NewSprintExp)
%     hold on
%
%
% VO2=NewSprintExp(a).VO2t;
% MP=NewSprintExp(a).MP;
%
% MPkj=MP/1000;              % J->kJ
% MPVO2=(MPkj/kE)*1000;       % L->mL
% MPVO2=MPVO2*60;
%
% AnBel=cumsum(MPVO2)-cumsum(VO2);
%
% dAnBel=diff(AnBel);
% for b=1:length(AnBel)-2
%     if AnBel(b)<0
%         if dAnBel(b)>0 && dAnBel(b+1)<=0
%             AnBel(b:end)=AnBel(b:end)-AnBel(b);
%         end
%         AnBel(b)=0;
%     end
% end
%
%     heat=AnBel;
%     x=1:length(heat);
%     y=zeros(size(x)) - a;
%     z=zeros(size(x));
%     col=heat';
%
%     surface([x;x],[y;y],[z;z],[col;col],...
%         'facecol','no','edgecol','interp','linew',27);
% end
%
% sgtitle('Anaerobe Belastung','fontweight','bold','interpreter','latex');
% set(gcf,'units','centimeter','position',[5,2,30,20])
%
% set(gca,'XTick', 0:5*600:S,'xticklabel',xLabel)
% xlabel('Zeit [min]')
%
% yLabel=flip(Nachname);
% set(gca,'YTick', -length(LfdNr):-1)
% set(gca,'yticklabel',yLabel)
% ylim([-length(LfdNr)-0.5 -0.5])
%
% colorbar
% colormap(jet);
%
% end
%% old stuff


% b=length(NewSprintExp(:,5));
% h=max(length(NewSprintExp{1,5}),length(NewSprintExp{2,5}));
% test=zeros(h,b);
% for ee=1:length(NewSprintExp)
%     test(1:length(NewSprintExp{ee,8}),ee)=movmean(NewSprintExp{ee,8},3000);
% end

% newmap = jet;                    %starting map
% ncol = size(newmap,1);           %how big is it?
% zpos = 1 + floor(2/3 * ncol);    %2/3 of way through
% newmap(zpos,:) = [1 1 1];        %set that position to white
% colormap(newmap);                %activate it
%
% N = 64;   % or whatever
% Color1 = [ones(N,1),(N-1:-1:0)'/(N-1),zeros(N,1)];
% colormap(Color1)


%     figure(1)
%     hold on
%     EEperc=kcalg*100./sum(kcalg,2);         % Logarithmus?
%     b=barh(EEperc(:,:), 'stacked')
%     xlim([0 100])
%     alpha(0.3)
%     alpha(b,0.6)
%     set(gca,'YTick',1:length(EEperc),'YAxisLocation','right','yticklabel',exporttxt(:,1));
%     set(gca,'XTick',0:20:100,'TickLength',[0 0]);
%     set(gcf,'units','centimeter','position',[5,5,7,20])
%     hold off
%
% print(['Urkunden\' num2str(j)], '-dpng');
% close(gcf)

% fill([0 0 9 9],[70 92 92 70],rgb('Salmon'),'LineStyle','none')
% fill([0 0 9 9],[92 97 97 92],rgb('SandyBrown'),'LineStyle','none')
% fill([0 0 9 9],[97 103 103 97],[1 1 1],'LineStyle','none')
% fill([0 0 9 9],[103 108 108 103],rgb('PaleGreen'),'LineStyle','none')
% fill([0 0 9 9],[108 130 130 108],rgb('MediumSeaGreen'),'LineStyle','none')
% fill([0 0 9 9],[99.8 100.2 100.2 99.8],'r','LineStyle','none')

% b=bar(x,Z,0.6, 'LineStyle','none','FaceColor',rgb('CornflowerBlue'));
% ylabel('Z-Wert')
% hold off
% text(x,Z,num2str(Z,'%0.0f'),'HorizontalAlignment','center','VerticalAlignment','bottom')