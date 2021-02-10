clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=4;

loadSettings()

Ref=AllRef(ProfileId).Ref(4);

DB=[char(RootF) '\DataBase'];
cd(DB)

allFiles = dir('*.mat');
allNames = { allFiles.name };

%% pick Session
pick=(8:length(allNames));
allNames=allNames(pick);
mode=2;         % Training
%% Create Reports
Session=1;
for Session=1:numel(allNames)
    
    cd(DB)
    Datafile=char(allNames(Session));
    Struct=load(Datafile);
    cd(baseF)
    
    CreateReport(Struct,VarNames,Ref,RootF,mode);
       
    fprintf('%d ', Session);
end