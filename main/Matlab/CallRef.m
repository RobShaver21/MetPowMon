clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=5;
loadSettings()

allNames=getAnalyzedSessions(P.Rootfolder);

Name='X';

%% pick Sessions

Sessions=1:3;
allNames=allNames(Sessions);

%% load data

T=getTablesforRef(allNames,P);

%% calc Ref

Output=RefCalc(T,S.VarNames,Name);
[S,P]=appendRef(S,Output,ProfileId);

%%
cd(baseF)
save Settings.mat S
