function [Norm, pos]=newplayer(P,Nr,Vorname,Nachname)

Norm=P.Norm;
SourceId=P.SourceId;
%% Polar
if SourceId==1
    if sum(Nr==Norm{:,2})==0            %Neuen Spieler hinzufügen
        l=height(Norm)+1;
        Norm.LfdNr(l)=l;
        Norm.SpielerNr(l)=Nr;
        Norm.Nachname(l)=Nachname;
        Norm.Vorname(l)=Vorname;
        Norm.Gewicht(l)=nanmean(Norm.Gewicht);
        Norm.EC0(l)=nanmean(Norm.EC0);
        Norm.info(l)="Mittelwerte des Teams";
    end
    
    pos=find(Norm{:,2}==Nr);
    
    %% Kinexxon
elseif SourceId==4
    [~,pos]=ismember([Vorname Nachname],strcat(Norm.Vorname, Norm.Nachname));
    if sum(pos)==0         %Neuen Spieler hinzufügen
        pos=height(Norm)+1;
        Norm.LfdNr(pos)=pos;
        Norm.SpielerNr(pos)=Nr;
        Norm.Nachname(pos)=Nachname;
        Norm.Vorname(pos)=Vorname;
        Norm.Gewicht(pos)=nanmean(Norm.Gewicht);
        Norm.MP4(pos)=nanmean(Norm.MP4);
        Norm.EC0(pos)=nanmean(Norm.EC0);
        Norm.info(pos)="Mittelwerte des Teams";
    end
    
    
    %% Polar API
elseif SourceId==3 
    % handling strings when there is no subject information
     if ischar(Nr)
        [id,pos]=ismember(Nr,Norm.Vorname);
        Nr=[];
        Nr(id)=Norm.SpielerNr(pos(id));
        Nr(~id)=height(Norm)+100;  
    end
    
    if sum(Nr==Norm.SpielerNr)==0        %Neuen Spieler hinzufügen
        l=height(Norm)+1;
        Norm.LfdNr(l)=l;
        Norm.SpielerNr(l)=Nr;
        Norm.Nachname(l)=cellstr(Nachname);
        Norm.Vorname(l)=cellstr(Vorname);
        Norm.Gewicht(l)=nanmean(Norm.Gewicht);
        Norm.MP4(l)=nanmean(Norm.MP4);
        Norm.EC0(l)=nanmean(Norm.EC0);
        Norm.info(l)=cellstr("Mittelwerte des Teams");
    end
    
    pos=find(Norm.SpielerNr==Nr);
end

