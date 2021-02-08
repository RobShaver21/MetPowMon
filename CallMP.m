clearvars; close all; clc;

%% Settings

ProfileId=4;        % 1=VFL 2=Hockey 3=EHF 4=HoNaMa

loadSettings()

Datum=datestr(now,'dd.mm.yyyy_HHMM');

cd(RootF)

if ~isfolder('DataBase')
    mkdir DataBase;
end
cd('DataBase'); DB=pwd;
cd(DataF)

if ~isnan(RefId)
    Norm=AllRef(ProfileId).Norm;
end

%% file structure
if SourceId==1      % Polar Download
    
    X=dir('*.xls'); X={X.name};              % X <- Übersichtsdateien
    Y=dir('*'); Y=Y([Y.isdir]); Y={Y.name};  % Y <- Ordner der Spiele
    Y=Y(strlength(Y)>2);
    FolderStruct=struct(X,Y);
    
elseif SourceId==4      % Kinexxon
    cd(RootF);  G=readtable('Phase.csv'); cd(DataF);     % read Table for cutting data
    Field=nan;
    
    STR=dir('*.csv'); STR={STR.name};
    Smatch=extractBetween(STR,'match=','_')';
    Smatch=str2double(Smatch);
    Steam=extractBetween(STR,'team=','_')';
    Snumber=extractBetween(STR,'number=','_')';
    Snumber=str2double(Snumber);
    Splayer=extractBetween(STR,'player=','.csv')';
    Y=unique(Smatch);
    
end
%% pick Sessions
Sessions=[1:5];
if SourceId==1
    X=X(Sessions);
    Y=Y(Sessions);
elseif SourceId==4
    Y=Y(Sessions);
end

%% run script
analyzeGames()

%% Export
exportTables()