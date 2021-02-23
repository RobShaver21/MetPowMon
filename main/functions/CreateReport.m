 function CreateReport(Struct,VarNames,Ref,RootF,mode)
% mode: 1 = Spiel, 2 = Training
%% settings
fprintf('Prepare Data...')

template=[pwd, '\templaterpt.dotx'];
path= char(RootF);
cd(path)
mkdir temp;

set(0,'DefaultFigureVisible','off');
warning('off','MATLAB:MKDIR:DirectoryExists');
warning('off','MATLAB:table:ModifiedVarnames');
warning('off','MATLAB:table:RowsAddedExistingVars');

import mlreportgen.report.*; import mlreportgen.dom.*;

%% Import Data, extract relevant Data


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
select=[8 5 11 13 14 17 18 30 56]; %Vars from VarNames
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

%% Create Tables
CreateTables()

fprintf('Done.\n')

%% Plots
Paths=struct();
Paths.P=[path '\Report\Plots\'];
Paths.Plot=[Paths.P Einheit '_'];
Paths.Report=[path '\Report\'];

if ~isfolder(Paths.P)
    mkdir(Paths.P); end

if ~isfolder(Paths.Report)
    mkdir(Paths.Report); end

%% Refplot
fprintf('Create Teamplot...')
RefPlot=plotReference(Zteam);
Paths.RefBar=[Paths.Plot 'RefBar.jpg'];
exportgraphics (RefPlot,Paths.RefBar);

%% Scatter Plot Hi-Events
TeamSc=TeamScatter(Struct,3);
Paths.TeamScatter=[Paths.Plot 'TeamSc.jpg'];
exportgraphics(TeamSc,Paths.TeamScatter);

%% Energie Team
EEbar=plotEEbarindv(TableImp, 3000,'sum');
Paths.EEbar=[Paths.Plot 'EEbar.jpg'];
exportgraphics(EEbar,Paths.EEbar);

% Create energy-bar for mean team per quarter
EEbarteam=plotEEbarindv(TableImp,200,'mean');
Paths.EEbarteam=[Paths.Plot 'EEbarteam.jpg'];
exportgraphics(EEbarteam,Paths.EEbarteam);

%% Progress Plots Team: Prep

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
%% Progress Plots Team : Print
for a=1:length(progselect)
    [img]=ParProg(T1,T2,date,a);
    Paths.Prog(a).Plots=[Paths.Plot 'ProgTeam_' progvarnames{a} '.jpg'];
    exportgraphics(img,Paths.Prog(a).Plots);
end

fprintf('Done.\n')

%% Progress Plots Ind.: Prep
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
%% Progress Plots Ind.: Loop

for a=1:length(Nachname)
    
    fname =[char(Nachname(a)) '_' char(Vorname (a))];
    
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
        
        log=string(IndSessionProg.Nachname)==string(Nachname{a});
        iIndSessionProg=IndSessionProg(log,:);
        
        str2=VarNames.Var(progselect)';
        str1=string(iIndSessionProg.Properties.VariableNames);
        pos = arrayfun(@(x) find(string(str1)==x,1,'first'),string(str2));
        
        d=iIndSessionProg.Datum;
        savename=varsstr;
        
        for p=1:length(pos)
            T1=iIndProg;
            T2=iIndSessionProg(:,pos); T2=[table(d) T2];
            [img]=ParProg(T1,T2,date,p);
            Paths.Ind(a).Prog(p).Plot=...
                [Paths.Plot 'Prog_' fname '_' savename{p} '.jpg'];
            exportgraphics(img,Paths.Ind(a).Prog(p).Plot);
        end
    catch
    end
    
    % EEbar
    EEind=plotEEbarindv(indv_plot_table,200,'sum');
    Paths.Ind(a).EEbar=[Paths.Plot fname '_EEbar.jpg'];
    exportgraphics (EEind, Paths.Ind(a).EEbar);
    % VO2
    try
    VO2ind=Vector(indv_plot_index);
    VO2q=VO2quarter(VO2ind,indv_plot_table.VO4,Einheit);
    Paths.Ind(a).VO2=[Paths.Plot fname '_VO2.jpg'];
    exportgraphics (VO2q, Paths.Ind(a).VO2);
    catch
    end
    %RefInd
    try
        Refindv=plotIndReference(PercIndTeam,PercInd,a);
        Paths.Ind(a).Ref=[Paths.Plot fname '_Refind.jpg'];
        exportgraphics (Refindv, Paths.Ind(a).Ref);
    catch
    end
    
end
clear a;
%% TwoPar
Team_prog= TwoPar(ExTableTeam);
Paths.TwoPar=[Paths.Plot fname '_TwoPar.jpg']; %Team_prog.png -> TwoPar
exportgraphics(Team_prog,Paths.TwoPar);

fprintf('Done.\n')


%% Part 1 - Zsfg.: Table, E-Bar, Ref
fprintf('Create Report...')

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

% MeanTeamTable
TableSummary = Section;
TableSummary.Title = Text('Teamauswertung');
TableSummary.Title.Color = 'black';
TableSummary.Numbered = 0;
tablerpt = tablecreate(1,MeanTeamTable.Properties.VariableNames,...
    MeanTeamTable(1:m,(1:width(MeanTeamTable))),MeanTeamTable(f,(1:width(MeanTeamTable))));
add(TableSummary,tablerpt);
add(P1,TableSummary);
Plots = Section;
Plots.Numbered=0;
Plots.Title = title_save;

% Team_progPlot und EEbarPlot
lo_table=plotimplement(4,Paths.TwoPar,Paths.EEbar);
add(Plots,lo_table);

%RefPlot
Refsec=Section();
Refsec.Title=title_save;
Refbar=plotimplement(1,Paths.RefBar);
add(Refsec,Refbar);
add(P1,Plots);
add(P1,Refsec);

%% Part 2 - Ind. Übersichtstabelle, VO2-Scatter
P2= Chapter();
P2.Numbered = 0;
P2.Layout.Landscape= 1;
P2.TemplateName = 'Table';
P2.TemplateSrc = template; %"templaterpt.dotx";

% IndTeamTable
comtable=Section();
comtable.Title= Paragraph('Teamübersicht - Gesamt');
comtable.Title.Color = 'black';
comtable.Numbered=0;
tablecom=tablecreate(2,IndTeamTable.Properties.VariableNames,...
    IndTeamTable,fusscom);
add(comtable,tablecom);

% scatter plot
Scatter=Section();
Scatter.Title=title_save;
scatterplot=plotimplement(5,Paths.TeamScatter);
add(Scatter,scatterplot);
add(P2,comtable);
add(P2,Scatter);

%% Part 3 - Prog-Plots
Progp=Chapter();
Progp.Numbered=0;
Progp.TemplateName = 'Indv';
Progp.TemplateSrc = template; % "templaterpt.dotx";
Progplot=Section();
Progplot.Title='Verlauf im Längsschnitt';
Progplot.Numbered=0;

for a=1:length(progselect)
    progplot=plotimplement(2,Paths.Prog(a).Plots);
    add(Progplot,progplot);
end

add(Progp,Progplot);

%% Part 4 - Legende

P3 = Chapter();
P3.Numbered = 0;
P3.TemplateName = 'Indv';
P3.TemplateSrc = template; % "templaterpt.dotx";
Legende=legende();
add(P3,Legende);

%% Construct Report
%Erste und zweite Seite vordefinieren, rpt erstellen in for schleife packen, Individuelle Seiten anfügen, individuell benennen? Über struct aufrufen?

doctype = "docx";

if ~exist([path,char(Einheit)], 'dir')
    mkdir Report;
end

Paths.SaveReport=[Paths.Report char(Einheit) '\'];
rpt = Report('Hockey - Report',doctype);  %Create Report container
rpt.OutputPath=Paths.SaveReport;

add(rpt,TocP);

if mode==1
    add(rpt,P1);
end
add(rpt,P2);
add(rpt,Progp);
add(rpt,P3);
%% Part 5 - Individualauswertungen
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
    
    c=strcmp(Temp.Name,Nachname(a));
    IndTable=Temp(c,(1:width(Temp)));
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
    elseif height(IndTable)>1
        IndTable=IndTable(IndTable.Phase==categorical("Gesamte Einheit"),:);
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
    % EEbar
    lo_table_indv=plotimplement(4,Paths.Ind(a).EEbar,Paths.EEbar);
    % Refbar
    Refbarind=plotimplement(1,Paths.Ind(a).Ref);
    
    if mode == 1
        add(indv_plots,lo_table_indv);
        add(indv_plots,Refbarind);
    end
    % VO2
    try
    VO2indv=plotimplement(3,Paths.Ind(a).VO2);
    add(indv_plots,VO2indv);
    catch
    end
    
    for p=1:length(pos)
        try
            Prog_ind=plotimplement(2,Paths.Ind(a).Prog(p).Plot);
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




