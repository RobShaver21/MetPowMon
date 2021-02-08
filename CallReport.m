clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=4;  

loadSettings()

Ref=AllRef{1,ProfileId}{1,2}(4);

cd(RootF)
cd('DataBase')
allFiles = dir('*.mat');
allNames = { allFiles.name };

Session=17;

%% Create Reports
for Session=1:numel(allNames)
    cd(RootF)
    cd('DataBase')
    Datafile=char(allNames(Session));
    Struct=load(Datafile);
    CreateReport(Struct,VarNames,Ref,RootF, 2);
    fprintf('%d ', Session);
end