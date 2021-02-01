function [VO2Tn]=VO2t(MP,ts,tau)
% 

VO2Tn=NaN(size(MP));
VO2Tn(1)=nanmean(MP(1:10));

for r=2:length(MP)
VO2Tn(r) = (MP(r) - VO2Tn(r-1)) * (1 - exp(-ts/tau)) + VO2Tn(r-1);
end

%% Versuch: Anaerobe Belastung
% AE=MP-VO2Tn;
% sAE=cumsum(AE);
% 
% dAE=diff(sAE);         % difference to determine local minima     
% for a=1:length(sAE)-2
%     if sAE(a)<0                           % for all negative values: set zero
%         if dAE(a)>0 && dAE(a+1)<=0        % detect change of sign for local minimum
%             sAE(a:end)=sAE(a:end)-sAE(a);     % lift up the rest of v to the actual value(v(a))
%         end
%         sAE(a)=0;                         
%     end
% end


%%
% plot(sAE./1000)
% hold on
% figure
% plot(VO2Tn)
end
