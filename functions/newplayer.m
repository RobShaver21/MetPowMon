function [Norm, pos,info]=newplayer(Nr,Norm,Vorname,Nachname,SourceId)

%% Polar
if SourceId==1       
    if sum(Nr==Norm{:,2})==0            %Neuen Spieler hinzufügen
        l=height(Norm)+1;
        Norm.LfdNr(l)=l;
        Norm.SpielerNr(l)=Nr;
        Norm.Nachname(l)=Nachname;
        Norm.Vorname(l)=Vorname;
        Norm.Gewicht(l)=nanmean(Norm.Gewicht);
        Norm.MP4(l)=nanmean(Norm.MP4);
        Norm.EC0(l)=nanmean(Norm.EC0);
        info=['Die Werte von Spieler*in '  Vorname ' ' Nachname...
            ' wurden anhand der Mittelwerte der anderen Spieler*innen berechnet'];
    end
    
    pos=find(Norm{:,2}==Nr); 
end

%% Kinexxon
if SourceId==4      
    log=[Vorname Nachname]==strcat(Norm.Vorname, Norm.Nachname);
    if sum(log)==0         %Neuen Spieler hinzufügen
        l=height(Norm)+1;
        Norm.LfdNr(l)=l;
        Norm.SpielerNr(l)=Nr;
        Norm.Nachname(l)=Nachname;
        Norm.Vorname(l)=Vorname;
        Norm.Gewicht(l)=nanmean(Norm.Gewicht);
        Norm.MP4(l)=nanmean(Norm.MP4);
        Norm.EC0(l)=nanmean(Norm.EC0);
        info=['Die Werte von Spieler*in '  Vorname ' ' Nachname...
            ' wurden anhand der Mittelwerte der anderen Spieler*innen berechnet'];
    end
 
    log=[Vorname Nachname]==strcat(Norm.Vorname, Norm.Nachname);
    pos=find(log);
    
 
end


%% Test
% test=NaN(size(Splayer));
% for bb=1:length(Splayer)
%     
%     player=(Splayer(bb));
%     player=split(player(ab));
%     player(cellfun('isempty',player)) = []; % remove empty cells from mm
%     Vorname=player{1};
%     Nachname=player{end};
%     Nr=Snumber(bb);
%     Names=strcat(Norm.Vorname, Norm.Nachname);
%     log=[Vorname Nachname]==Names;
%     test(bb)=sum(log);
% end
% log2=find(test==0);
% unique(Splayer(log2))
    
    
