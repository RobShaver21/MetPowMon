function DataStruct=cutdatafromgame(dataG,data,P,Nr)

SourceId=P.SourceId;
fs=P.Source.ts;

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
    clock0=[clock; hours(24)];
    
    tp=arrayfun(@(x) find(clock0>=x,1,'first'),tdur);
    tp(tp>numel(clock))=numel(clock);
    
    newtp=clock(tp);
    dur=diff(newtp,1,2);
    dur=datestr(dur,'HH:MM:SS');
    t1=datestr(newtp(:,1),'HH:MM:SS');
    t2=datestr(newtp(:,2),'HH:MM:SS');
    dur=datestr(dur,'HH:MM:SS');
    
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
    St=dataG.markers;
    St(end+1).start_time=dataG.Beginn;
    St(end).end_time=dataG.Ende;
    tdur=string([{St.start_time}; {St.end_time}]);
    tdur=datetime(tdur,'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss');
    Ges=[data.clock(1);data.clock(end)];
    tdur=[tdur Ges];
    [y, m, d]= ymd(tdur);
    tdur=tdur-datetime(y,m,d,0,0,0);
    tdur=tdur';
    [y, m, d]=ymd(data.clock(1));
    clock=data.clock-datetime(y,m,d,0,0,0);
    data.clock=clock;
    clock0=[clock; hours(24)];
    
    tdur(isnan(tdur(:,2)),2)=max(tdur(:,2));
    tdur(isnan(tdur(:,1)),1)=min(tdur(:,1));

    tp=arrayfun(@(x) find(clock0>=x,1,'first'),tdur);
    tp(tp>numel(clock))=numel(clock);
    
    newtp=clock(tp);
    dur=diff(newtp,1,2);
    dur=datestr(dur,'HH:MM:SS');
    t1=datestr(newtp(:,1),'HH:MM:SS');
    t2=datestr(newtp(:,2),'HH:MM:SS');
   
    St(end).name='Gesamte Einheit';
    St(end+1).name='Gesamt';
    Phase={St.name};
    
    Name=[dataG.Vorname ' ' dataG.Nachname];
    
    Einheit=datetime(dataG.Beginn, 'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss');
    Einheit=datestr(Einheit,'yyyymmdd_HHMMSS');
    for a=1:numel(St)
        
        DataStruct(a).Phase=Phase{a};
        DataStruct(a).Table=data(tp(a,1):tp(a,2),:);
        DataStruct(a).Dauer=dur(a,:);
        DataStruct(a).Beginn=t1(a,:);
        DataStruct(a).Ende=t2(a,:);
        DataStruct(a).Name=Name;
        DataStruct(a).Einheit=Einheit;
        
    end
    
    % clear empty struct fields
    id=cellfun(@height,{DataStruct.Table})<=1;
    DataStruct(id)=[];

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
    clock=string(datestr(data.clock));                    % t-Vec from data
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
     
    tp = arrayfun(@(x) find(clock>=x,1,'first'),tdur);

    dur=tdur(:,2)-tdur(:,1);                % dataG
    Add(log,:)=[];
    check=sum(seconds([dur-Add])>1);

    t1=datestr(tdur(:,1),'HH:MM:SS');
    t2=datestr(tdur(:,2),'HH:MM:SS');
    dur=datestr(dur,'HH:MM:SS');
    
    tdur2=clock(tp);                        % corresponding values from data
    durT=tdur2(:,2)-tdur2(:,1);
    t12=datestr(tdur2(:,1),'HH:MM:SS');
    t22=datestr(tdur2(:,2),'HH:MM:SS');
    dur2=datestr(durT,'HH:MM:SS');
    durSum=minutes(sum(durT));
    %
    
    
    DataStruct(1).Phase="Brutto";
    DataStruct(1).Table=data;
    DataStruct(1).Dauer=height(data)*0.066 /60;
    DataStruct(1).Beginn=datestr(clock(1),'HH:MM:SS');
    DataStruct(1).Ende=datestr(clock(end),'HH:MM:SS');
    DataStruct(1).Name=Name;
    DataStruct(1).Einheit=Einheit;
    
    DataStruct(1).AddDataRows=Empty;       % add dummy data from phase 1
    DataStruct(1).AddDataRows.Properties.VariableNames=NewName;
    
    
    for a=1:length(tp(:,1))
        DataStruct(a+1).Phase=dataG.PhaseId(a);
        DataStruct(a+1).Table=data(tp(a,1):tp(a,2),:);
        DataStruct(a+1).Dauer=minutes(durT(a,:));
        DataStruct(a+1).Beginn=t12(a,:);
        DataStruct(a+1).Ende=t22(a,:);
        DataStruct(a+1).Name=dataG.Name(a);
        DataStruct(a+1).Einheit=dataG.MatchID(a);
        
        DataStruct(a+1).PhaseType=dataG.PhaseType{a};
        DataStruct(a+1).AddDataRows=dataG(a,:);
        DataStruct(a+1).AddDataRows.Properties.VariableNames=NewName;
        
    end
    
    %try
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
        
        
    %catch end
    
    
    
end




end
