clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_Eagle
ProfileId=1;        

loadSettings()

Datum=datestr(now,'dd.mm.yyyy_HHMM');

%% file structure

Files=getSessionsToAnalyze(P);

%% pick Sessions
Sessions=[1];

Files.Y=Files.Y(Sessions);
if P.SourceId==1
    Files.X=Files.X(Sessions);
    Files.Y=Files.Y(Sessions);
elseif P.SourceId==4
    %
elseif P.SourceId==3
    Files.Y(Sessions);
end

%% run script

P=analyzeGames(S,P,Files,Datum);

%% Export

exportTables(Files,P)

%% save Norm

S.Profile(ProfileId).Norm=P.Norm;

cd(baseF)

save Settings.mat S