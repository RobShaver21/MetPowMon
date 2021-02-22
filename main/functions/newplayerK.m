function [Norm, info]=newplayerK(Nr1,Norm,Vorname,Nachname)

log=[Vorname Nachname]==strcat(Norm.Vorname, Norm.Nachname);
    if sum(log)==0         %Neuen Spieler hinzufügen
        l=height(Norm)+1;
        Norm.LfdNr(l)=l;
        Norm.SpielerNr(l)=Nr1;
        Norm.Nachname(l)=Nachname;
        Norm.Vorname(l)=Vorname;
        Norm.Gewicht(l)=nanmean(Norm.Gewicht);
        Norm.MP4(l)=nanmean(Norm.MP4);
        Norm.EC0(l)=nanmean(Norm.EC0);
        info=['Die Werte von Spieler*in '  Vorname ' ' Nachname...
            ' wurden anhand der Mittelwerte der anderen Spieler*innen berechnet'];
    end
end
