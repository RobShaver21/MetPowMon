clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_Eagle
ProfileId=2;        

loadSettings()

Datum=datestr(now,'dd.mm.yyyy_HHMM');

cd(P.Rootfolder)

if ~isfolder('DataBase')
    mkdir DataBase;
end

cd('DataBase'); DB=pwd;

%% file structure

Files=getSessionsToAnalyze(P);

%% pick Sessions
Sessions=[17];
if SourceId==1
    Files.X=Files.X(Sessions);
    Files.Y=Files.Y(Sessions);
elseif SourceId==4
    Files.Y=Files.Y(Sessions);
end

%% run script
analyzeGames()

%% Export
exportTables()

%% save Norm
cd(baseF)

if ~isnan(RefId)
    S.Profile(ProfileId).Norm=P.Norm;
end

save Settings.mat S