
clearvars; close all; clc;
cd (['C:\Users\' getenv('username') '\MATLAB Drive\MP']);
addpath (genpath(pwd))
ProfileId=4;

load Settings.mat; % load DataBase.mat

[RootF,DataF,varset,GameId,SourceId,RefId,PInd,ts,tsg]=...
    profileset(DataProfile,DataSource,ProfileId);

Ref=AllRef{1,ProfileId}{1,2}(4);

cd(RootF)
cd('DataBase')
allFiles = dir('*.mat');
allNames = { allFiles.name };

Session=17;

for Session=1:numel(allNames)
    cd(RootF)
    cd('DataBase')
    Datafile=char(allNames(Session));
    Struct=load(Datafile);
%     Struct=Database.SaveStruct;
%     Struct=DataBase{ProfileId}(Session);
    CreateReport(Struct,VarNames,Ref,RootF, 2);
    fprintf('%d ', Session); 
end