function T=getTablesforRef(allNames,P)

cd(P.DataBase)

for a=1:numel(allNames)
    load(allNames{a})
    if a==1
        T=SaveStruct.Table;
    else
        T=[T; Struct.Table];
    end
end