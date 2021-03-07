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

[id,log] = ismember(MeanTeamZ.Phase,TeamMeanRef.Phase);
log(~id)=[];

DiffTeam=MeanTeamZ(id,:);
Zteam=DiffTeam;
PercTeam=DiffTeam;

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