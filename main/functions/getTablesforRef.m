function T=getTablesforRef(allNames,P)

cd(P.DB)

for a=1:numel(allNames)
    load(allNames{a})
    if a==1
        T=SaveStruct.Table;
    else
        T=[T; SaveStruct.Table];
    end
end