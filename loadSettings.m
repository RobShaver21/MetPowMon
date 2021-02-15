baseF= ['C:\Users\' getenv('username') '\MATLAB Drive\MetPowMon'];
cd(baseF)
addpath(genpath(pwd));
load Settings.mat;

if exist('ProfileId','var')==1
    P=profileset(S,ProfileId);
end

