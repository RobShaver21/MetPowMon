function Output=RefCalc(AllTables,VarNames,Name)

%% individual reference table

classes=varfun(@class,AllTables);    % identify scalars
log=arrayfun(@(x) strcmp(classes{1,x},'double'),1:width(classes));

IndFilter={'Vorname','Nachname','Phase'};
IndMean=groupsummary(AllTables,IndFilter,'mean',log);
IndSD=groupsummary(AllTables,IndFilter,'std',log);

varheader=(AllTables.Properties.VariableNames(log))';
indheader=[IndFilter'; {'count'};  varheader];

IndMean.Properties.VariableNames=indheader;
IndSD.Properties.VariableNames=indheader;

%% team reference table

SessionFilter={'Einheit','Phase'};
SessionMean=groupsummary(AllTables,SessionFilter,'mean',log);
SessionMean=removevars(SessionMean,{'GroupCount'});
sessionheader=[SessionFilter'; varheader];
SessionMean.Properties.VariableNames=sessionheader;


classes2=varfun(@class,SessionMean);     % identify scalars
log2=arrayfun(@(x) strcmp(classes2{1,x},'double'),1:width(classes2));

TeamFilter={'Phase'};
TeamMean=groupsummary(SessionMean,TeamFilter,'mean',log2);
TeamSD=groupsummary(SessionMean,TeamFilter,'std',log2);

teamheader=[TeamFilter; {'count'}; varheader];

TeamMean.Properties.VariableNames=teamheader;
TeamSD.Properties.VariableNames=teamheader;

%% output

Output=struct('Name',Name, 'TeamMean',TeamMean,'TeamSD',TeamSD,...
    'IndMean',IndMean,'IndSD',IndSD,'SessionMean',SessionMean,'AllTables',AllTables);

end


