clearvars; close all; clc;
baseF= pwd;
addpath(genpath(pwd));
load Settings.mat;
%% Settings
ProfileId=4;

[RootF,DataF,varset,GameId,SourceId,RefId,PInd,ts,tsg]=...
    profileset(DataProfile,DataSource,ProfileId);

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