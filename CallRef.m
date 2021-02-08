clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=4;    

loadSettings()

cd(RootF)
cd('DataBase')
allFiles = dir('*.mat');
allNames = { allFiles.name };

Name='8.1-27.1.2021';

%% load data
for a=1:numel(allFiles)
    load(allNames{a})
    if a==1
        T=Struct.Table;
    else
        T=[T; Struct.Table];
    end
end
%% calc Ref

Output=RefCalc(T,VarNames,Name);
AllRef{1,ProfileId}{1,2}(end+1)=Output;

cd(baseF)
save Settings.mat AllRef DataProfile DataSource Mail VarNames Fields
