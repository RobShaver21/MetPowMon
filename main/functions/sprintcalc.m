function [count, inrangeends, inrangeduration, mean]=sprintcalc(par,bound,ts,t1,t2)

% input:
% par:      Parameter-Input as n x 1 - Vector
% bound:    desired threshold for counting events
% ts:       sampling rate, e.g. 0.1 for 10 Hz
% t1:       Time above threshold (bound) for valid count
% t2(opt.): Time between events considered to merge events


log=par>bound;
mean=movmean(log,t1/ts);
vec=mean==1;
if exist ('t2')
mean=movmean(vec,t2/ts)>=1/(t2/ts);
end
transitions = diff([false; mean; false]);
inrangestarts = find(transitions == 1);
inrangeends = find(transitions == -1);
count = length(inrangeends);
inrangeduration = (inrangeends - inrangestarts)*ts; 
end

