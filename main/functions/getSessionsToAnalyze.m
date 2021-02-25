function Files=getSessionsToAnalyze(P)
cd(P.Datafolder)
if P.SourceId==1      % Polar Download
    
    X=dir('*.xls'); 
    Files.X={X.name};              % X <- Übersichtsdateien
    Y=dir('*'); Y=Y([Y.isdir]); Y={Y.name};  % Y <- Ordner der Spiele
    Files.Y=Y(strlength(Y)>2);
    
elseif P.SourceId==4      % Kinexxon
    cd(P.Rootfolder);  
    G=readtable('Phase.csv'); % read Table for cutting data
    cd(P.Datafolder);     
    
    STR=dir('*.csv'); STR={STR.name};
    Smatch=extractBetween(STR,'match=','_')';
    Files.Smatch=str2double(Smatch);
    Files.Steam=extractBetween(STR,'team=','_')';
    Snumber=extractBetween(STR,'number=','_')';
    Files.Snumber=str2double(Snumber);
    Files.Splayer=extractBetween(STR,'player=','.csv')';
    Files.Y=unique(Smatch);
    
elseif P.SourceId==3      % Polar API
    
    Y=dir('*.mat'); 
    Files.Y={Y.name};

end