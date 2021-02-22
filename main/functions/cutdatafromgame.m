function DataStruct=cutdatafromgame(dataG,data,SourceId,Nr)

%% Polar
if SourceId==1
    
    posPG=find(dataG.Spielernummer==Nr);   %Reihe Spieler in Übersichtsdatei
    Phase=dataG.Phasenname(posPG);
    Phase=[{'Gesamt'}; Phase];
    
    OldName=dataG.Properties.VariableNames;
    NewName=OldName;
    for p=1:length(OldName)
        NewName(p)={['Sys_' OldName{p}]};
    end
    
    
    clock=data.clock(:);
    tdur=table2array(dataG(posPG,7:8));
    [y, m, d]= ymd(tdur);
    tdur=tdur-datetime(y,m,d,0,0,0);
    tdur=[clock(1) clock(end); tdur];
    dur=tdur(:,2)-tdur(:,1);
    t1=datestr(tdur(:,1),'HH:MM:SS');
    t2=datestr(tdur(:,2),'HH:MM:SS');
    dur=datestr(dur,'HH:MM:SS');
    
    tp=[1 height(data)];
    try
        tp = arrayfun(@(x) find(clock>=x,1,'first'),tdur);
        
        
    catch
    end
    % copy, if ind. time was shorter than session
    if numel(tp)<3
        tp=[tp;tp];
    end
    
    for a=1:length(tp(:,1))
        DataStruct(a).Phase=Phase{a};
        DataStruct(a).Table=data(tp(a,1):tp(a,2),:);
        DataStruct(a).Dauer=dur(a,:);
        DataStruct(a).Beginn=t1(a,:);
        DataStruct(a).Ende=t2(a,:);
        DataStruct(a).Name=dataG.Spielername{posPG};
        DataStruct(a).Einheit=dataG.NameDesTrainings{posPG};
        if ~(a==1) % add data rows from game data
            DataStruct(a).AddDataRows=dataG(posPG(a-1),:);
            DataStruct(a).AddDataRows.Properties.VariableNames=NewName;
        else
            DataStruct(a).AddDataRows=dataG(posPG(a),:);
            DataStruct(a).AddDataRows.Properties.VariableNames=NewName;
        end
    end

%%
elseif SourceId==3
    
    
%% Kinexon
elseif SourceId==4
    % dataG=Gplayer;      % remove later
    NewName=dataG.Properties.VariableNames;
    
    for p=1:length(NewName)
        NewName(p)={['Kin_' NewName{p}]};
    end
    Name=dataG.Name{1};
    Einheit=dataG.MatchID(1);
    
    log=dataG.Netto==0;
    if sum(log)>0
        Empty=dataG(log,:);
        Empty=Empty(1,:);
    else
        Empty=dataG(1,:);
    end
    
    %     dataG(log,:)=[];      % select netto only
    
    %
    clock=data.clock(:);                    % t-Vec from data
    clock=split(clock);
    clock=duration(clock(:,2));              % convert to duration array
    
    Begin=dataG.PhaseBegin;                 % Begin + End from dataG
    Begin=extractAfter(Begin,'T');
    Begin=duration(Begin);                  % convert to duration array
    Begin=Begin+hours(1);
    Add=seconds(dataG.PhaseLength_s_);
    End=Begin+Add;                          % calculate end time
    
    tdur=[Begin End];
    
    log=tdur(:,2)>clock(end);
    tdur(log,:)=[];
    
    try     tp = arrayfun(@(x) find(clock>=x,1,'first'),tdur);
    catch end
    
    
    dur=tdur(:,2)-tdur(:,1);                % dataG
    t1=datestr(tdur(:,1),'HH:MM:SS');
    t2=datestr(tdur(:,2),'HH:MM:SS');
    dur=datestr(dur,'HH:MM:SS');
    
    tdur2=clock(tp);                        % corresponding values from data
    durT=tdur2(:,2)-tdur2(:,1);
    t12=datestr(tdur2(:,1),'HH:MM:SS');
    t22=datestr(tdur2(:,2),'HH:MM:SS');
    dur2=datestr(durT,'HH:MM:SS');
    durSum=datestr(sum(durT),'HH:MM:SS');
    %
    
    
    DataStruct(1).Phase="Brutto";
    DataStruct(1).Table=data;
    DataStruct(1).Dauer=height(data)*0.066 /60;
    DataStruct(1).Beginn=data.clock(1);
    DataStruct(1).Ende=data.clock(end);
    DataStruct(1).Name=Name;
    DataStruct(1).Einheit=Einheit;
    
    DataStruct(1).AddDataRows=Empty;       % add dummy data from phase 1
    DataStruct(1).AddDataRows.Properties.VariableNames=NewName;
    
    
    for a=1:length(tp(:,1))
        DataStruct(a+1).Phase=dataG.PhaseId(a);
        DataStruct(a+1).Table=data(tp(a,1):tp(a,2),:);
        DataStruct(a+1).Dauer=dur2(a,:);
        DataStruct(a+1).Beginn=t12(a,:);
        DataStruct(a+1).Ende=t22(a,:);
        DataStruct(a+1).Name=dataG.Name(a);
        DataStruct(a+1).Einheit=dataG.MatchID(a);
        
        DataStruct(a+1).PhaseType=dataG.PhaseType{a};
        DataStruct(a+1).AddDataRows=dataG(a,:);
        DataStruct(a+1).AddDataRows.Properties.VariableNames=NewName;
        
    end
    
    try
        DataStruct(end+1).Phase="Netto";
        DataStruct(end).AddDataRows=Empty;       % add dummy data from phase 1
        DataStruct(end).AddDataRows.Properties.VariableNames=NewName;
        
        NetTable=vertcat(DataStruct.AddDataRows);
        log=NetTable.Kin_Netto==1; log(1)=0;
        
        DataStruct(end).Table=vertcat(DataStruct(log).Table);
        DataStruct(end).Dauer=durSum;
        DataStruct(end).Beginn=t12(1,:);
        DataStruct(end).Ende=t22(end,:);
        DataStruct(end).Name=dataG.Name(1);
        DataStruct(end).Einheit=dataG.MatchID(1);
        
        
    catch end
    
    
    
end




end
