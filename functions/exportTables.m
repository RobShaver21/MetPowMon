function exportTables(P,Datum)

cd(P.DB)

D=dir('*.mat'); D={D.name};

for e=1:length(D)
    load(D{e})
    if e==1
        Meta=SaveStruct.Table;
    else
        Meta=[Meta;SaveStruct.Table];
    end
end

cd(P.T.Rootfolder)

if ~isfolder('Export')
    mkdir Export;
end

cd('Export')

writetable(Meta,['Export_' Datum '.xlsx'])
end