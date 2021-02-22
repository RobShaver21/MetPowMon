function P=addDataBase(P)
cd(P.Rootfolder)

if ~isfolder('DataBase')
    mkdir('DataBase')
end

cd('DataBase')

P.DB=pwd;
end