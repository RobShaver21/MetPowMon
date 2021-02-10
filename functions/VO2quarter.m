function [img]=VO2quarter(Vector,MP4,Einheit)

% Vector=Struct.VectorExport; % already defined in main script

ts=0.1;     %ts input definieren
MP4=MP4(1);
% convert Phase to string
str=strings(length(Vector),1);
for cc=1:length(Vector)
    str(cc)=string(Vector(cc).Phase);
end

% extract quarter
log1=strcmp(str,"Gesamte Einheit");
log2=strcmp(str,"Gesamt");
log=log1|log2;

NewVector=Vector;
NewVector(log)=[];

% extract player - kann/sollte vorher geschehen, entweder als Input-
% variable oder noch besser vor der Funktion
if length(NewVector)>3
    IndVector=NewVector(1:4);
    
    % plot
    img=figure ;%('visible','on');
    %     tiledlayout instead subplot for exportgraphics
    img = tiledlayout (2,2);
    for i=1:4
        try
            nexttile
            t=[ts:ts:(length(IndVector(i).VO2t)*ts)]';
            plot(t, IndVector(i).VO2t);
            MP4label=sprintfc('%5.1f',MP4);
            yline(MP4,'--r',['MP4' MP4label],'LabelVerticalAlignment','middle');
            mw=nanmean(IndVector(i).VO2t);
            mwlabel=sprintfc('%5.1f',mw);
            yline(mw,'--b',['MW' mwlabel],'LabelVerticalAlignment','middle');
            nrstr=num2str(i);
            title([nrstr '. Viertel']);
            xlim([0 20*60]);
            ylim([0 70]);
            xLabel=[0:5:20];
            set(gca,'XTick', 0:5*60:20*60,'xticklabel',xLabel);
            xlabel('Zeit [min]');
        catch
        end
    end
else
    
    str=string({Vector.Phase}');
    log=strcmp(str,"Gesamte Einheit");
    Vector=Vector(log,:);
    v=Vector.VO2t;

    Einheit=datetime(Einheit,'InputFormat','yyyyMMdd_HHmmss');
    H=timeofday(Einheit);
    
    d=Vector.Uhr(1);
    d=datetime(d,'InputFormat','HH:mm:ss.SSS');
    d=timeofday(d);
    d=seconds(H-d)*10;
    x=1:length(v);
    x=x+d;
    
    % t=[ts:ts:length(v)*ts]';
    figure%('visible','on')
    plot (x,v);
  
     % title('$$\dot{V}$$O2 in ml/min/kg','fontweight','bold','interpreter','latex','fontsize',16);
    ylim([0 70]);
 
    xLabel=0:5:length(v)/600;

    set(gca,'XTick', 0:5*600:length(v),'xticklabel',xLabel)
    xlabel('Zeit [min]');
    MP4label=sprintfc('%5.1f',MP4);
    yline(MP4,'--r',['MP4' MP4label],'LabelVerticalAlignment','middle');
    mw=nanmean(v);
    mwlabel=sprintfc('%5.1f',mw);
    yline(mw,'--b',['MW' mwlabel],'LabelVerticalAlignment','middle');
    img=gca;
end

sgtitle('$$\dot{V}$$O2 in ml/min/kg','fontweight','bold','interpreter','latex','fontsize',16);

set(gcf,'units','centimeter','position',[5,2,30,20]);

% % für später: Teamvergleich
% TeamVO2=cat(2,NewSprintExp.VO2t)
% mTeamVO2=mean(TeamVO2,2);
% sdTeamVO2=std(TeamVO2,0,2);
% t=NewSprintExp.Uhr;
% plot(t,mTeamVO2)

%set(gca,'XTick', 0:5*600:S,'xticklabel',xLabel)
end