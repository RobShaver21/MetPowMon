function [Nr,Vorname,Nachname]=extractFolderInfo(str)

%str=Z{ab}

parts=split(str);
NumOrNan=cellfun(@(x) str2double(x), parts);

Nr=NumOrNan(~isnan(NumOrNan));
Nr=Nr(1);

Strings=parts(isnan(NumOrNan));
Vorname=Strings{1};
Nachname=Strings{end};