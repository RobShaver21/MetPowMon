function [histTime, histVar1, histVar2]=histo(VecIn, thresh, ts, Var1, Var2)


%%
VecIn=(1:1e4)';
thresh=[0 10 100 150 300 1000 2350];
Var1=rand(size(VecIn));
Var2=rand(size(VecIn));
ts=0.1;

%%
threshUp=[thresh(2:end) 1e5];

id=VecIn>=thresh & VecIn<threshUp;

histTime=sum(id)*ts/60;

histVar1=arrayfun(@(x) nansum(Var1(id(:,x))),1:numel(histTime))

if exist('Var2','var')
    histVar2=arrayfun(@(x) nansum(Var2(id(:,x))),1:numel(histTime))
end

end
