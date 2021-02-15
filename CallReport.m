clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=4;

mode=2;         % Training

loadSettings()

Ref=AllRef(ProfileId).Ref(1);

allNames=getAnalyzedSessions(RootF)


%% pick Session
pick=1:17;
allNames=allNames(pick);
Session=1;

%% Create Reports

for Session=1:numel(allNames)
    
    cd(DB)
    Datafile=char(allNames(Session));
    Struct=load(Datafile);
    cd(baseF)
    
    CreateReport(Struct,VarNames,Ref,RootF,mode);
       
    fprintf('%d ', Session);
end