function exportTables(Files,P)

Datum=datestr(now,'dd.mm.yyyy_HHMM');

cd(P.DB)

%Files=dir('*.mat'); Files={Files.name};

for e=1:length(Files)
    load(Files{e})
    if e==1
        Meta=SaveStruct.Table;
    else
        Meta=[Meta;SaveStruct.Table];
    end
end

cd(P.Rootfolder)

if ~isfolder('Export')
    mkdir Export;
end

cd('Export')

writetable(Meta,['Export_' Datum '.xlsx'])

end