function [P]=analyzeGames(S,P,Files,Datum)

Version='Beta';    %% Skriptversion
aa=1; ab=1;

%% Schleife Games/Ordner

for aa=1:length(Files.Y)
    cd(P.Datafolder)
    
    if P.SourceId==1              % Polar
        cd(P.Datafolder)
        dataG=readgamedata(Files.X,Files.Y,aa,P.GameId);
        cd(Files.Y{aa})
        Z=dir('* *'); Z={Z.name}; % Z <- Spieler
        games=split(Files.Y{aa}, '_');
        Einheit=[games{1} '_' games{2}];
        GameF=pwd;
        
    elseif P.SourceId==4          % Kinexxon
        Glog=Files.Smatch==Files.Y{aa};
        Z=Files.STR(Glog);
        GameF=P.Datafolder;
        str1=Files.Smatch(Glog);str1=string(str1(1));
        str2=unique(Steam(Glog))'; str2=string(str2);
        Einheit=strcat(str1,"_",str2(1),"_",str2(2));
        
        log=Files.G.MatchID==str2num(str1);
        Gsub=Files.G(log,:);
        
    elseif P.SourceId==3          % Polar API
        cd(P.Datafolder)
        file=Files.Y{aa};
        load(file)
        Z=Dout;
        Einheit=extractBefore(file,'.mat');
     
    end
    
    %% Schleife Spieler
    
    for ab=1:length(Z)
        
        if P.SourceId==1      % Polar
            cd(GameF)
            player=split(Z{ab});
            SpielerNr=player{1};
            Vorname=player{P.PlayerInd};
            Nachname=player{end};
            Nr=str2double(SpielerNr);
            [P.Norm, pos]=newplayer(Nr,P.Norm,Vorname,Nachname,P.SourceId);       %info bearbeiten
            
            old=pwd;
            cd(Z{ab});
            N=dir('*.csv'); N={N.name};                 % N <- Dateien der Spieler
            data=readtable(N{1});           % Iport Funktion
            data=convertdata(data,P.Source,P.SourceId);
            data=AddGpx(data);
            cd(old);
            
            [DataStruct]=cutdatafromgame(dataG,data,P.SourceId,Nr); 
            
        elseif P.SourceId==4      % Kinexxon
            playerO=(Files.Splayer(Glog));
            player=split(playerO(ab));
            player(cellfun('isempty',player)) = []; % remove empty cells from mm
            Vorname=player{1};
            Nachname=player{end};
            Nr=Files.Snumber(Glog);
            Nr=Nr(ab);
            [P.Norm, pos]=newplayer(Nr,P.Norm,Vorname,Nachname,P.SourceId);
            data=readtable(Z{ab});
            data=convertdata(data,varset,P.SourceId);
            
            log=strtrim(string(playerO{ab}))==string(Gsub.Name);
            Gplayer=Gsub(log,:);
            
            [DataStruct]=cutdatafromgame(Gplayer,data,P.SourceId,Nr); 
            
        elseif P.SourceId==3          % Polar API
            Vorname=Z(ab).Vorname;
            Nachname=Z(ab).Nachname;
            Nr=Z(ab).SpielerNr;
            [P.Norm, pos]=newplayer(Nr,P.Norm,Vorname,Nachname,P.SourceId);
            data=Z(ab).Daten;
            data=convertdata(data,P.Source,P.SourceId);
            [DataStruct]=cutdatafromgame(Z(ab),data,P.SourceId,Nr); 
            
        end
        %% Calculation
        
        Str=table({Version},{Datum},{Einheit},{Vorname},{Nachname},{Nr},...
            'VariableNames', {'Version','Datum', 'Einheit','Vorname','Nachname','SpielerNr'});
        
        if  P.SourceId==4
            temp=Files.Steam(Glog);  Str.Team=string(temp{ab}); end
        
        for am=1:length(DataStruct)
            DataS=DataStruct(am);
            try
                [Features, Vecs]=FeatureCalc(DataS,Str,P.Norm,S.Fields,P.Source.ts,pos);
                if am==1 && ab==1
                    Export=Features;
                    SprintExp=Vecs;
                else
                    Export=[Export;Features];
                    SprintExp=[SprintExp;Vecs];
                end
            catch
            end
        end
        
        %% display progress
        perc=round(100*((aa-1)/length(Files.Y)+(ab/length(Z))/length(Files.Y)),1);
        fprintf(1,[num2str(perc) ' %'])
        
    end       % Spieler-Schleife
    
    %% clean & save data
    
    cd(P.DB);
    SaveStruct=struct(...
        'Einheit',Einheit,'Table',Export,...
        'VectorExport',SprintExp,'Datum',{Datum});
    save(strcat(Einheit, '.mat'),'SaveStruct');
    clear SaveStruct Export VecExp
     
    cd(P.Rootfolder)
    
end       % Game-Schleife




