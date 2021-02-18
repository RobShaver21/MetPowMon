clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=4;    

loadSettings()

allNames=getAnalyzedSessions(P.T.Rootfolder)

Name='8.1-28.1.2021';

%% pick Sessions
Sessions=17;
allNames=allNames(Sessions);

%% load data

T=getTablesforRef(allNames,P)

%% calc Ref

Output=RefCalc(T,VarNames,Name);
S.Profile(ProfileId).Ref(end+1)=Output;

cd(baseF)
save Settings.mat S
