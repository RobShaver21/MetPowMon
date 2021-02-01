%% Metabolic Power 2020

Version='Beta';    %% Skriptversion
aa=1; ab=1;

%% Schleife Games/Ordner

for aa=1:length(Y)
    if SourceId==1      % Polar
        cd(DataF)
        dataG=readgamedata(X,Y,aa,GameId);
        cd(Y{aa})
        Z=dir('* *');  Z={Z.name};        % Z <- Spieler
        games=split(Y{aa}, '_');
        Einheit=[games{1} '_' games{2}];
        GameF=pwd;
        
    elseif SourceId==4      % Kinexxon
        Glog=Smatch==Y(aa);
        Z=STR(Glog);
        GameF=DataF;
        str1=Smatch(Glog);str1=string(str1(1));
        str2=unique(Steam(Glog))'; str2=string(str2);
        Einheit=strcat(str1,"_",str2(1),"_",str2(2));
        
        log=G.MatchID==str2num(str1);
        Gsub=G(log,:);
    end
    
    %% Schleife Spieler
    
    for ab=1:length(Z)
        cd(GameF)
        
        if SourceId==1      % Polar
            player=split(Z{ab});
            SpielerNr=player{1};
            Vorname=player{PInd};
            Nachname=player{end};
            Nr=str2double(SpielerNr);
            [Norm, pos]=newplayer(Nr,Norm,Vorname,Nachname,SourceId);       %info bearbeiten
            
            old=pwd;
            cd(Z{ab});
            N=dir('*.csv'); N={N.name};                 % N <- Dateien der Spieler
            data=readtable(N{1});           % Import Funktion
            data=convertdata(data,varset,SourceId);
            data=AddGpx(data);
            cd(old);
            
            [DataStruct]=cutdatafromgame(dataG,data,SourceId,Nr); % Daten schneiden anhand der Übersichtsdatei if id=1
            
        elseif SourceId==4      % Kinexxon
            playerO=(Splayer(Glog));
            player=split(playerO(ab));
            player(cellfun('isempty',player)) = []; % remove empty cells from mm
            Vorname=player{1};
            Nachname=player{end};
            Nr=Snumber(Glog);
            Nr=Nr(ab);
            [Norm, pos]=newplayer(Nr,Norm,Vorname,Nachname,SourceId);
            data=readtable(Z{ab});
            data=convertdata(data,varset,SourceId);
            
            log=strtrim(string(playerO{ab}))==string(Gsub.Name);
            Gplayer=Gsub(log,:);
            
            [DataStruct]=cutdatafromgame(Gplayer,data,GameId,SourceId,Nr); % Daten schneiden anhand der Übersichtsdatei if id=1
            
        end
        %% Calculation
        
        Str=table({Version},{Datum},{Einheit},{Vorname},{Nachname},{Nr},...
            'VariableNames', {'Version','Datum', 'Einheit','Vorname','Nachname','SpielerNr'});
        
        if  SourceId==4
            temp=Steam(Glog);  Str.Team=string(temp{ab}); end
        
        for am=1:length(DataStruct)
            DataS=DataStruct(am);
            try
                [Features, Vecs]=FeatureCalc(DataS,Str,Norm,Field,ts,pos,0);  % NaNs in Rohdaten.
                if am==1 && ab==1
                    Export=Features;
                    SprintExp=Vecs;
                else
                    Export=[Export;Features];
                    SprintExp=[SprintExp;Vecs];
                end
            catch end
        end
        
        %% display progress
        perc=round(100*((aa-1)/length(Y)+(ab/length(Z))/length(Y)),1);
        fprintf(1,[num2str(perc) ' %'])
        
    end       % Spieler-Schleife
    
    %% clean & save data
    
    cd(DB);
    SaveStruct=struct('Einheit',Einheit,'Table',Export,...
        'VectorExport',SprintExp,'Datum',{Datum});
    save(strcat(Einheit, '.mat'),'SaveStruct');
    clear SaveStruct
    clear Export VecExp
    
    cd(RootF)
    
end       % Game-Schleife




