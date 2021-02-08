cd(DB)

if ~isfolder('Export')
    mkdir Export;
end


D=dir('*.mat'); D={D.name};

for e=1:length(D)
    load(D{e})
    if e==1
        Meta=SaveStruct.Table;
    else
        Meta=[Meta;SaveStruct.Table];
    end
end

cd(RootF)
cd('Export')

writetable(Meta,['Export_' Datum '.xlsx'])