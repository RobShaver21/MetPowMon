function allNames=getAnalyzedSessions(Rootfolder)

cd(Rootfolder)
cd('DataBase')

allNames=dir('*.mat');
allNames={allNames.name};
end