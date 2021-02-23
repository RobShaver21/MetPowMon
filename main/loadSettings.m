baseF= 'C:\Users\Robin\MATLAB Drive\MetPowMon\main';
cd(baseF)
addpath(genpath(pwd));
load Settings.mat;

if exist('ProfileId','var')==1
    P=profileset(S,ProfileId);
    P=addDataBase(P);
end

