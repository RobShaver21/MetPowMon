function [RootF,DataF,varset, GameId,SourceId,RefId,PInd,ts,tsg]=profileset(DataProfile,DataSource,ProfileId)

    RootF=DataProfile.Rootfolder(ProfileId);
    DataF=DataProfile.Datafolder(ProfileId);
    GameId=DataProfile.GameId(ProfileId);
    SourceId=DataProfile.SourceId(ProfileId);
    RefId=DataProfile.RefId(ProfileId);
    PInd=DataProfile.PlayerInd(ProfileId,:);
    ts=DataSource.ts(SourceId);
    tsg=DataSource.tsg(SourceId);
    varset=DataSource(SourceId,:);

end
