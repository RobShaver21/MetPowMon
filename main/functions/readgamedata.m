function [dataG]=readgamedata(X,Y,aa,id)

if id==1
    for posG=1:length(X)        % Position Übersichtsdatei
        if X{posG}(1:13)==Y{aa}(1:13)
            break
        end
    end
    
    dataG=readtable(X{posG});       % Übersichtsdatei einlesen
end
end
