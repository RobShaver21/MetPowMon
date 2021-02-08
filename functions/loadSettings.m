baseF= pwd;
addpath(genpath(pwd));
load Settings.mat;

[RootF,DataF,varset,GameId,SourceId,RefId,PInd,ts,tsg]=...
    profileset(DataProfile,DataSource,ProfileId);

