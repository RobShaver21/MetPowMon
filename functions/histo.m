function [timevec, depvec1, depvec2]=histo(ind, thresh, ts, dep1, dep2)

vectord=[thresh(2:end) 1000];

log1=ind>=thresh;
log2=ind>=vectord;
log=log1~=log2;

timevec=sum(log)*ts/60;

depvec1=NaN(size(timevec));
depvec2=NaN(size(timevec));

for a=1:length(timevec)
depvec1(a)=nansum(dep1(log(:,a)));
end

try
for a=1:length(timevec)
depvec2(a)=nansum(dep2(log(:,a)));
end
catch
end


end
