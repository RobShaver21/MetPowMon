function CreateReport(Struct,VarNames,Ref,RootF, mode)
% mode: 1 = Spiel, 2 = Training
%% settings
fprintf('Prepare Data...')
cd (['C:\Users\' getenv('username') '\MATLAB Drive\MP']);
template=[pwd, '\templaterpt.dotx'];
path= char(RootF); addpath(genpath(pwd));
cd(path)
mkdir temp;
set(0,'DefaultFigureVisible','off');
warning('off','MATLAB:MKDIR:DirectoryExists');
warning('off','MATLAB:table:ModifiedVarnames');
warning('off','MATLAB:table:RowsAddedExistingVars');

import mlreportgen.report.*; import mlreportgen.dom.*;

%% Import Data for using, Extract relevant Data

% load Database.mat;
% Struct=DataBase{2}(5);  % example; define numbers
TableImp=Struct.SaveStruct.Table;
Vector=Struct.SaveStruct.VectorExport;
Einheit=Struct.SaveStruct.Einheit;

% Vor- und Nachname aus der ersten Einheit
[LfdNr, ia]=unique([Struct.SaveStruct.VectorExport.LfdNr]);
Nachname=TableImp.Nachname(ia).';
Vorname=TableImp.Vorname(ia).';
namelog=strcat(Vorname.', {' '}, Nachname.');
date=datetime(Einheit,'InputFormat','yyyyMMdd_HHmmss','Format','dd.MM.yy HH:mm');
Datum=datestr(date, 'dd.mm.yy HH:MM');

RefC=Ref;

%% Properties and PreTable

%Variable selection
select=[8 5 11 13 14 17 18 30]; %Vars from VarNames
pselect=[14 17]; 
progselect=[13 14 17 18];
strnr=3;
namepos=2;

selectn=select; selectn(namepos)=[]; selectn=selectn-1;

vars=VarNames.Var(select);
iround=VarNames.RoundNrI(select); %round single values
tround=VarNames.RoundNrT(select); %round means
tround(namepos)=[];
varsn=vars; varsn(namepos)=[];
varsstr=vars; varsstr(1:strnr)=[];
header=VarNames.Header(select);
theader=header;
theader(namepos)=[]; % delete name from header
varheader=header; varheader(1:strnr)=[];
PreTable=TableImp(:,vars);
PreTable.Properties.VariableNames=header;

% Transformation EDI und AI
PreTable.("Anaerober Index [%]")=PreTable.("Anaerober Index [%]")*100;
PreTable.("EDI [%]")=(PreTable.("EDI [%]")-1)*100;

RefC.TeamMean.EDI=(RefC.TeamMean.EDI-1)*100;
RefC.TeamSD.EDI=(RefC.TeamSD.EDI-1)*100;
RefC.IndMean.EDI=(RefC.IndMean.EDI-1)*100;
RefC.IndSD.EDI=(RefC.IndSD.EDI-1)*100;
RefC.SessionMean.EDI=(RefC.SessionMean.EDI-1)*100;
RefC.AllTables.EDI=(RefC.AllTables.EDI-1)*100;

RefC.TeamMean.AnaeroberIndex=(RefC.TeamMean.AnaeroberIndex)*100;
RefC.TeamSD.AnaeroberIndex=(RefC.TeamSD.AnaeroberIndex)*100;
RefC.IndMean.AnaeroberIndex=(RefC.IndMean.AnaeroberIndex)*100;
RefC.IndSD.AnaeroberIndex=(RefC.IndSD.AnaeroberIndex)*100;
RefC.SessionMean.AnaeroberIndex=(RefC.SessionMean.AnaeroberIndex)*100;
RefC.AllTables.AnaeroberIndex=(RefC.AllTables.AnaeroberIndex)*100;

% VarNames for plots
pvarnames=VarNames.Var([8 pselect]); 
% check for game data
log=string(PreTable.Phase)=='Gesamte Einheit';
if sum(log)==0
    return
end

%% Table 1: Mean Team Table

MeanTeam=groupsummary(PreTable,{'Phase', 'Dauer'},'mean',(strnr+1):width(PreTable));

log=string(MeanTeam.Phase)=="Gesamt";
MeanTeam(log,:)=[];
MeanTeam=removevars(MeanTeam,{'GroupCount'});
MeanTeam.Properties.VariableNames= varsn;
MeanTeam.Properties.VariableDescriptions= theader;

% extract variables for plots
ExTableTeam=MeanTeam(:,pvarnames);

MeanTeamTable=RoundConvert(MeanTeam,tround);
MeanTeamTable.Properties.VariableNames= theader;
MeanTeamTable = convertvars(MeanTeamTable,(1:numel(varsn)),'categorical');
if height(MeanTeamTable)>4, f=5; m=4; else f=1;m=1; end
fusscom=table2array(MeanTeamTable(f,:));
MeanTeamTable(:,VarNames.Header(pselect))=[];
% MeanTeamTable(:,select)=[];
% footer table
fuss=table2array(MeanTeamTable(f,:));

%% Table 2: Ind. Team Table

Temp=RoundConvert(PreTable,iround);
Temp.Properties.VariableNames=header;

namelog=strcat(Vorname.', {' '}, Nachname.');

log=string(Temp.Phase)=='Gesamte Einheit';
IndTeamTable=Temp(log,:);
IndTeamTable=removevars(IndTeamTable,{'Phase'});
% table_ges{[1:height(table_ges)],1}=namelog;
IndTeamTable=convertvars(IndTeamTable,(1:length(select)-1),'categorical');
Temp(:,VarNames.Header(pselect))=[];

%% Z values cross sectional (ind vs team)

MeanTeamZ=groupsummary(PreTable,{'Phase'},'mean',(strnr+1):width(PreTable));
SdTeamZ=groupsummary(PreTable,{'Phase'},'std',(strnr+1):width(PreTable));
MeanTeamZ=removevars(MeanTeamZ,{'GroupCount'});
SdTeamZ=removevars(SdTeamZ,{'GroupCount'});

zvars=vars((strnr+1):end);
zvars=[{'Phase'}; varsstr];
MeanTeamZ.Properties.VariableNames=zvars;
SdTeamZ.Properties.VariableNames=zvars;

DiffIndTeam=PreTable;
ZIndTeam=PreTable;
PercIndTeam=PreTable;

log = arrayfun(@(x) find(string(MeanTeamZ.Phase)==x,1,'first'),string(DiffIndTeam.Phase));

DiffIndTeam{:,(strnr+1:end)}=(ZIndTeam{:,(strnr+1:end)}-MeanTeamZ{log,(strnr-1):end});
ZIndTeam{:,(strnr+1:end)}=(DiffIndTeam{:,(strnr+1:end)}./SdTeamZ{log,(strnr-1):end});
PercIndTeam{:,(strnr+1:end)}=(DiffIndTeam{:,(strnr+1:end)}./MeanTeamZ{log,(strnr-1):end});

% log=string(PreTable.Phase)=='Gesamt';
% ZTable(log,:)=[];

%% Z values team longitudinal section (mean values)

refvarsT=(RefC.TeamMean.Properties.VariableNames)';

log = arrayfun(@(x) find(string(refvarsT)==x,1,'first'),string(zvars));
TeamMeanRef=RefC.TeamMean(:,log);
TeamSdRef=RefC.TeamSD(:,log);

log = arrayfun(@(x) find(string(TeamMeanRef.Phase)==x,1,'first'),...
    string(MeanTeamZ.Phase));

DiffTeam=MeanTeamZ;
Zteam=MeanTeamZ;
PercTeam=MeanTeamZ;

DiffTeam{:,((strnr-1):end)}=(DiffTeam{:,((strnr-1):end)}-TeamMeanRef{log,(strnr-1):end});
Zteam{:,((strnr-1):end)}=(DiffTeam{:,((strnr-1):end)}./TeamSdRef{log,(strnr-1):end});
PercTeam{:,((strnr-1):end)}=(DiffTeam{:,((strnr-1):end)}./TeamMeanRef{log,(strnr-1):end});


%% Z values ind. longitudinal section (single values)

refvarsI=(RefC.IndMean.Properties.VariableNames)';
zvarsI=vars;
zvarsI(3)=[];       % remove duration

log = arrayfun(@(x) find(string(refvarsI)==x,1,'first'),string(zvarsI));
IndMeanRef=RefC.IndMean(:,log);
IndSdRef=RefC.IndSD(:,log);

log=RefC.IndMean.count<3;
IndMeanRef{log,strnr:end}=NaN;
IndSdRef{log,strnr:end}=NaN;

str1=string(strcat(IndMeanRef.Phase, IndMeanRef.Nachname));
str2=string(strcat(PreTable.Phase, PreTable.Name));

bo = ismember(str2,str1);

log = arrayfun(@(x) find(string(str1)==x),...
    string(str2(bo)));

DiffInd=PreTable(bo,:);
ZInd=PreTable(bo,:);
PercInd=PreTable(bo,:);

DiffInd{:,((strnr+1):end)}=(DiffInd{:,((strnr+1):end)}-IndMeanRef{log,(strnr):end});
ZInd{:,((strnr+1):end)}=(DiffInd{:,((strnr+1):end)}./IndSdRef{log,(strnr):end});
PercInd{:,((strnr+1):end)}=(DiffInd{:,((strnr+1):end)}./IndMeanRef{log,(strnr):end});
fprintf('Done.\n')
%% Refplot
fprintf('Create Teamplot...')
RefPlot=plotReference(Zteam);
exportgraphics (RefPlot,[path,'\Report\Plots\' Einheit 'RefPlot.png'],'Resolution',500);
%% Scatter Plot Hi-Events
TeamSc=TeamScatter(Struct,3);
exportgraphics(TeamSc,[path,'\Report\Plots\' Einheit 'TeamSc.png'],'Resolution',500);
%% Energie Team
EEbar=plotEEbarindv(TableImp, 3000,'sum');
exportgraphics(EEbar,[path,'\Report\Plots\' Einheit 'EEbar.png'],'Resolution',500);
%Create energy-bar for mean team per quarter
EEbarteam=plotEEbarindv(TableImp,200,'mean');
exportgraphics(EEbarteam,[path,'\Report\Plots\' Einheit 'EEbarteam.png'],'Resolution',500);

%% Progress Plots Team

log=string(MeanTeam.Phase)=="Gesamte Einheit";
MT=MeanTeam(log,:);
MT=removevars(MT,{'Dauer','Phase'});

Sessions=RefC.SessionMean;
log=string(Sessions.Phase)=="Gesamte Einheit";
Sessions=Sessions(log,:);
Sessions.Datum=datetime(Sessions.Einheit,'InputFormat','yyyyMMdd_HHmmss',...
    'Format','dd.MM.yy HH:mm');
Sessions=sortrows(Sessions,'Datum','ascend');


str1=string(Sessions.Properties.VariableNames);
str2=string(MT.Properties.VariableNames);
progvarnames=VarNames.Var(progselect);
pos = arrayfun(@(x) find(string(str1)==x,1,'first'),string(str2));

savename=MT.Properties.VariableNames;
MT.Properties.VariableNames=varheader;
d=Sessions.Datum;

T1=MT(:,VarNames.Header(progselect));
T2=Sessions(:,VarNames.Var(progselect));
T2=[table(d) T2];

for a=1:length(progselect)
    [img]=ParProg(T1,T2,date,a);
    exportgraphics(img,[path,'\Report\Plots\' Einheit 'Prog' progvarnames{a} 'Team.png'],'Resolution',500);
end
% for p=1:length(pos)
%     try
%
%      T2=[T2 table(d)];
%     [img]=ParProg(T1,T2);
%     exportgraphics(img,[currentpath,'\Report\Plots\' Einheit 'Prog' savename{p} 'Team.png']);
%     catch
%     end
% end
% for p=1:length(pos)
%     try
%     T1=MT(:,p);
%     T2=Sessions(:,pos(p)); T2=[T2 table(d)];
%     [img]=ParProg(T1,T2);
%     exportgraphics(img,[currentpath,'\Report\Plots\' Einheit 'Prog' savename{p} 'Team.png']);
%     catch
%     end
% end
fprintf('Done.\n')
%% Progress Plots Ind. Preparation
fprintf('Create Indv. Plot...')
log=string(PreTable.Phase)=="Gesamte Einheit";
IndProg=PreTable(log,:);
P=IndProg(:,2);
IndProg(:,1:strnr)=[];
IndProg=[P IndProg];

IndSessionProg=RefC.AllTables;
log=string(IndSessionProg.Phase)=="Gesamte Einheit";
IndSessionProg=IndSessionProg(log,:);
IndSessionProg=removevars(IndSessionProg,{'Datum'});
IndSessionProg.Datum=datetime(IndSessionProg.Einheit,'InputFormat','yyyyMMdd_HHmmss',...
    'Format','dd.MM.yy');
IndSessionProg=sortrows(IndSessionProg,'Datum','ascend');
%% Indv. Plot

ProgNames=cell(size(Nachname));
for a=1:length(Nachname)
    
    fname =[char(Nachname(a)) ',' char(Vorname (a))];
    fname1=[char(Nachname(a)) ',' char(Vorname (a)) ' - EEbar'];
    fname2=[char(Nachname(a)) ',' char(Vorname (a)) ' - VO2'];
    fname3=[char(Nachname(a)) ',' char(Vorname (a)) ' - Refindv'];
    indv_plot_index=strcmp(TableImp.Nachname,Nachname(a));
    indv_plot_table=TableImp(indv_plot_index,(1:width(TableImp)));
    Phase=indv_plot_table.Phase;
    ExTableInd=indv_plot_table(:,VarNames.Var([8 pselect]));
    ExTableInd=sortrows(ExTableInd,'Phase');
    log=string(ExTableInd.Phase)=='Gesamt';
    ExTableInd(log,:)=[];
    
    % Prog
    try
        log=string(IndProg.Name)==Nachname{a};
        iIndProg=IndProg(log,VarNames.Header(progselect));
        %iIndProg=removevars(iIndProg,{'Name'});
        
        log=string(IndSessionProg.Nachname)==string(Nachname{a});
        iIndSessionProg=IndSessionProg(log,:);
        
        %         str2=string(varsstr)';
        str2=VarNames.Var(progselect)';
        str1=string(iIndSessionProg.Properties.VariableNames);
        pos = arrayfun(@(x) find(string(str1)==x,1,'first'),string(str2));
        
        d=iIndSessionProg.Datum;
        savename=varsstr;
        %         iIndSessionProg=iIndSessionProg(:,pos);
        ProgName=string(savename);
        
        for p=1:length(pos)
            T1=iIndProg;
            T2=iIndSessionProg(:,pos); T2=[table(d) T2];
            [img]=ParProg(T1,T2,date,p);
            ProgName(p)=['Prog' savename{p} fname '.png'];
            exportgraphics(img,[path '\Report\Plots\' Einheit '' char(ProgName(p))],'Resolution',500);
        end
        
        ProgNames{a}=ProgName;
    catch
    end
    % prog end
    
    EEind=plotEEbarindv(indv_plot_table,200,'sum');
    exportgraphics (EEind, [path,'\Report\Plots\' Einheit '',fname1,'.png'],'Resolution',500);
    VO2ind=Vector(indv_plot_index);
    VO2q=VO2quarter(VO2ind,indv_plot_table.VO4);
    exportgraphics (VO2q, [path,'\Report\Plots\' Einheit '',fname2,'.png'],'Resolution',500);
    try
    Refindv=plotIndReference(PercIndTeam,PercInd,a);
    exportgraphics (Refindv, [path,'\Report\Plots\' Einheit '',fname3,'.png'],'Resolution',500);
    catch
    end
    
end
clear a;
%% TwoPar
Team_prog= TwoPar(ExTableTeam);
exportgraphics(Team_prog,[path,'\Report\Plots\' Einheit 'Team_prog.png'],'Resolution',500);
fprintf('Done.\n')
%% Report Container
fprintf('Create Report...')
% Erste Seite
% Gesamtenergie statt Energie
title_h=Paragraph();
str1 = ("Auswertung vom ");
str2= string(Datum);
str3= strcat(str1,str2);
str3 = strjust(str3,'center');
title_h=append(title_h,str3);
title_save=Paragraph(' ','save');
% Toc
TocP=Section();
TocP.Numbered = 0;
TocP.TemplateName= 'Title';
TocP.TemplateSrc = template; %'templaterpt.dotx';
TocP.Title=title_h;
Toc=TableOfContents;
Toc.TemplateSrc = template; %  'templaterpt.dotx';
Toc.Title=Text('Inhaltsverzeichnis');
Toc.Title.Style={Bold(true)};
Toc.Title.FontSize='16';
add(TocP,Toc);

P1 = Chapter();
P1.Numbered = 0;
P1.TemplateName = 'Title';
P1.TemplateSrc = template; % "templaterpt.dotx";
P1.Layout.Landscape= 0;
TableSummary = Section;
TableSummary.Title = Text('Teamauswertung');
TableSummary.Title.Color = 'black';
TableSummary.Numbered = 0;
% Erstellt Formale Tabelle mit Header & Footer
tablerpt = tablecreate(1,MeanTeamTable.Properties.VariableNames,...
    MeanTeamTable(1:m,(1:width(MeanTeamTable))),MeanTeamTable(f,(1:width(MeanTeamTable))));
add(TableSummary,tablerpt);
add(P1,TableSummary);
Plots = Section;
Plots.Numbered=0;
Plots.Title = title_save;
Plota=[path,'\Report\Plots\' Einheit 'Team_prog.png'];
Plotb=[path '\Report\Plots\' Einheit 'EEbar.png'];
lo_table=plotimplement(4,Plota,Plotb);
add(Plots,lo_table);
Refsec=Section();
Refsec.Title=title_save;
plotref=[path,'\Report\Plots\' Einheit 'RefPlot.png'];
Refbar=plotimplement(1,plotref);
add(Refsec,Refbar);
add(P1,Plots);
add(P1,Refsec);
%Zweite Seite
P2= Chapter();
P2.Numbered = 0;
P2.Layout.Landscape= 1;
P2.TemplateName = 'Table';
P2.TemplateSrc = template; %"templaterpt.dotx";
comtable=Section();
comtable.Title= Paragraph('Teamübersicht - Gesamt');
comtable.Title.Color = 'black';
comtable.Numbered=0;
tablecom=tablecreate(2,IndTeamTable.Properties.VariableNames,...
    IndTeamTable,fusscom);
add(comtable,tablecom);
Scatter=Section();
Scatter.Title=title_save;
scatter = [path,'\Report\Plots\' Einheit 'TeamSc.png'];
%scatter2= [path,'\Report\Plots\' Einheit 'TeamSc2.png'];
scatterplot=plotimplement(5,scatter);
%scatter2plot=plotimplement(5,scatter2);
add(Scatter,scatterplot);
%add(Scatter,scatter2plot);
add(P2,comtable);
add(P2,Scatter);
Progp=Chapter();
Progp.Numbered=0;
Progp.TemplateName = 'Indv';
Progp.TemplateSrc = template; % "templaterpt.dotx";
Progplot=Section();
Progplot.Title='Verlauf im Längsschnitt';
Progplot.Numbered=0;
%         progplot=cell(1,length(progselect));
for a=1:length(progselect)
    plotprog=[path,'\Report\Plots\' Einheit 'Prog' progvarnames{a} 'Team.png'];
    progplot=plotimplement(2,plotprog);
    add(Progplot,progplot);
end
add(Progp,Progplot);
%         plotprog2=[currentpath,'\Report\Plots\' Einheit 'Prog' savename{2} 'Team.png'];
%         progplot2=plotimplement(2,plotprog2);
%         plotprog5=[currentpath,'\Report\Plots\' Einheit 'Prog' savename{5} 'Team.png'];
%         progplot5=plotimplement(2,plotprog5);
%
%         add(Progplot,progplot2);
%         add(Progplot,progplot5);



% Neue Belastungsseite
P3 = Chapter();
P3.Numbered = 0;
P3.TemplateName = 'Indv';
P3.TemplateSrc = template; % "templaterpt.dotx";
%     bel_table=Section();
%         add(bel_table,lo_table)
%     add(P3,bel_table)
Legende=legende();
add(P3,Legende);

%% Construct Report
%Erste und zweite Seite vordefinieren, rpt erstellen in for schleife packen, Individuelle Seiten anfügen, individuell benennen? Über struct aufrufen?

doctype = "docx";
% fname=[char(Nachname(a)) ',' char(Vorname (a)) ' - Report'];
% newSubfolder=sprintf('%s\%s',...
%     'C:\Users\Lump\Documents\MATLAB\Hockey\MP\Report\',char(Einheit));
if ~exist([path,char(Einheit)], 'dir')
    mkdir Report;
end
rpath=[path '\Report\' char(Einheit) '\'];
%     char(fname)];
rpt = Report('Hockey - Report',doctype);  %Create Report container
rpt.OutputPath=rpath;
%Allg. Tabellen vorher erstellen
add(rpt,TocP);
if mode==1
    add(rpt,P1);
end
add(rpt,P2);
add(rpt,Progp);
add(rpt,P3);
%Vierte Seite
fprintf('Add indv. plots...\n')
err=struct('msg', {});

for a=1:length(Nachname)
    P4= Chapter();
    P4.Numbered = 0;
    P4.Layout.Landscape= 0;
    P4.TemplateName = 'Indv';
    P4.TemplateSrc = template; % "templaterpt.dotx";
    % Individual Tabelle
    indv = Section;
    indvtitle=[namelog(a) ' - Individualauswertung'];
    indv.Title = indvtitle;
    indv.Numbered=0;
    %Reihen aus Pivottabelle nach Nachnamen
    %Vorschalten -> perfekte Tabelle um Daten zu nehmen
    c=strcmp(Temp.Name,Nachname(a));
    % Index=find(c);
    IndTable=Temp(c,(1:width(Temp)));
    %Create table for individual
    IndTable=sortrows(IndTable);
    index=string(IndTable.Phase)=={'Gesamt'};
    IndTable = convertvars(IndTable,(1:width(IndTable)),'categorical');
    IndTable.Name=[];
    fuss(1,1)={'Team - Ges.'};
    if height (IndTable)>2
        IndTable(height(IndTable)+1,1)={'Einheit'};
        IndTable(index,:)=[];
        table_indv=tablecreate(1,IndTable.Properties.VariableNames,IndTable,...
            fuss);
    else
        table_indv=tablecreate(1,IndTable.Properties.VariableNames,IndTable,...
            fuss);
    end
    add(indv,table_indv);
    add(P4,indv);
    % Individual Plots
    indv_plots = Section();
    indv_plots.Title= title_save;
    indv_plots.Numbered=0;
    Plotaindv=[path '\Report\Plots\' Einheit '',char(Nachname(a)) ',' char(Vorname (a)) ' - EEbar.png'];
    Plotbindv=[path '\Report\Plots\' Einheit 'EEbarteam.png'];
    lo_table_indv=plotimplement(4,Plotaindv,Plotbindv);
    
    refplotindv=[path '\Report\Plots\' Einheit '',char(Nachname(a)) ',' char(Vorname (a)) ' - Refindv.png'];
    Refbarind=plotimplement(1,refplotindv);
    if mode == 1
        add(indv_plots,lo_table_indv);
        add(indv_plots,Refbarind);
    end
    
    tileVO2indv=[path '\Report\Plots\' Einheit '',char(Nachname(a)) ',' char(Vorname (a)) ' - VO2.png'];
    VO2indv=plotimplement(3,tileVO2indv);
    add(indv_plots,VO2indv);
    for p=1:length(pos)
        try
            fname =[char(Nachname(a)) ',' char(Vorname (a))];
            progplotindv=[path '\Report\Plots\' Einheit '', char(ProgName(p))];%,fname, '.png'];
            
            Prog_ind=plotimplement(2,progplotindv);
            add(indv_plots,Prog_ind);
        catch ME
            err(end+1).msg=getReport(ME)
        end
    end
    
    add(P4,indv_plots);
    add(rpt,P4);
end

close(rpt);
fprintf('Done.\n')
fprintf('Save & Convert Report...')
docview(rpt.OutputPath,...
    'updatedocxfields','convertdocxtopdf',"closeapp");
% rmdir temp s
set(0,'DefaultFigureVisible','on');
warning('on','MATLAB:MKDIR:DirectoryExists');
warning('on','MATLAB:table:ModifiedVarnames');
warning('on','MATLAB:table:RowsAddedExistingVars');
fprintf('Done.\n')




