baseF= 'C:\Users\schaertb\MATLAB Drive\MetPowMon';
addpath(genpath(pwd));
load Settings.mat;

[RootF,DataF,varset,GameId,SourceId,RefId,PInd,ts]=...
    profileset(DataProfile,DataSource,ProfileId);

