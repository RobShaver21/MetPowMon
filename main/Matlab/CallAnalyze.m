clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_Eagle
ProfileId=3;        

loadSettings()

Datum=datestr(now,'dd.mm.yyyy_HHMM');

%% file structure

Files=getSessionsToAnalyze(P);

%% pick Sessions
Sessions=[1:10];

Files.Y=Files.Y(Sessions);

if P.SourceId==1
    Files.X=Files.X(Sessions);
end

%% run script

P=analyzeGames(S,P,Files,Datum);


%% save Norm

S.Profile(ProfileId).Norm=P.Norm;

cd(baseF)

save Settings.mat S