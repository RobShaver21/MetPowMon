function [load]=cTRIMP(HF,t,ts,HRrest,HRmax,a,b)
% HF: Heart Rate Vector
% t: time for cumulation in seconds
% ts: sampling rate in seconds
% HRrest & HRmax: min./max. Heart Rate
% a & b: coefficients for exp-function

mm=movmean(HF,t/ts);
I=[t/ts:t/ts:numel(HF)];
dHR=(mm(I)-HRrest)/(HRmax-HRrest);
y=a*exp(b*dHR);
pTRIMP=(t/60)*dHR.*y;
load=sum(pTRIMP);

end
