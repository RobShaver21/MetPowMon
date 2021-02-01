clearvars; close all; clc;
baseF= pwd;
addpath(genpath(pwd));
load Settings.mat;
%% Settings

ProfileId=4;

[RootF,DataF,varset,GameId,SourceId,RefId,PInd,ts,tsg]=...
    profileset(DataProfile,DataSource,ProfileId);

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
save Settings.mat AllRef DataProfile DataSource Mail VarNames

