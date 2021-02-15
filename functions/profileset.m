function P=profileset(S,ProfileId)

P=S.Profile(ProfileId);
P.Source=S.Source(P.SourceId,:);

% ab hier ggf. später löschen

%     RootF=DataProfile.Rootfolder(ProfileId);
%     DataF=DataProfile.Datafolder(ProfileId);
%     GameId=DataProfile.GameId(ProfileId);
%     SourceId=DataProfile.SourceId(ProfileId);
%     RefId=DataProfile.RefId(ProfileId);
%     PInd=DataProfile.PlayerInd(ProfileId,:);
%
%     ts=DataSource.ts(SourceId);
%     varset=DataSource(SourceId,:);
end

