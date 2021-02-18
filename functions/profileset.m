function P=profileset(S,ProfileId)

P=S.Profile(ProfileId);
P.Source=S.Source(P.SourceId,:);

end

