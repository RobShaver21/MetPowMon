function [S,P]=appendRef(S,Output,ProfileId)


if isempty(S.Profile(ProfileId).Ref)
    S.Profile(ProfileId).Ref=Output;
    P.Ref=Output;
else
    S.Profile(ProfileId).Ref(end+1)=Output;
    P.Ref(end+1)=Output;
end


end