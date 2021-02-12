clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=4;    

loadSettings()

cd(RootF)
cd('DataBase')
allFiles = dir('*.mat');
allNames = { allFiles.name };

Name='8.1-28.1.2021';

%% load data
for a=1:numel(allFiles)
    load(allNames{a})
    if a==1
        T=SaveStruct.Table;
    else
        T=[T; SaveStruct.Table];
    end
end
%% calc Ref

Output=RefCalc(T,VarNames,Name);
AllRef(ProfileId).Ref(end+1)=Output;

cd(baseF)
save Settings.mat AllRef DataProfile DataSource Mail VarNames Fields
