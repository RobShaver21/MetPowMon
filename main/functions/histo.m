function [histTime, histVar1, histVar2]=histo(VecIn, thresh, ts, Var1, Var2)

%%
threshUp=[thresh(2:end) 1e5];

id=VecIn>=thresh & VecIn<threshUp;

histTime=sum(id)*ts/60;

histVar1=arrayfun(@(x) nansum(Var1(id(:,x))),1:numel(histTime));

if exist('Var2','var')
    histVar2=arrayfun(@(x) nansum(Var2(id(:,x))),1:numel(histTime));
end

end
