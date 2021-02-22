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
        Norm.EC0(l)=nanmean(Norm.EC0);
        Norm.info(l)="Mittlelwerte des Teams";
    end

    pos=find(Norm{:,2}==Nr);
    
    %% Kinexxon
elseif SourceId==4
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
        Norm.info(l)="Mittlelwerte des Teams";
    end
    
    log=[Vorname Nachname]==strcat(Norm.Vorname, Norm.Nachname);
    pos=find(log);
    
    %% Polar API
elseif SourceId==3
    if sum(Nr==Norm.SpielerNr)==0            %Neuen Spieler hinzufügen
        l=height(Norm)+1;
        Norm.LfdNr(l)=l;
        Norm.SpielerNr(l)=Nr;
        Norm.Nachname(l)=Nachname;
        Norm.Vorname(l)=Vorname;
        Norm.Gewicht(l)=nanmean(Norm.Gewicht);
        Norm.MP4(l)=nanmean(Norm.MP4);
        Norm.EC0(l)=nanmean(Norm.EC0);
        Norm.info(l)="Mittlelwerte des Teams";
    end
    pos=find(Norm{:,2}==Nr); 
end

