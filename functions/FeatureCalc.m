function [Features, Vecs]=FeatureCalc(DataS,Str,Norm,Field,ts,pos,plotID)

t=DataS.Table.t;
s=DataS.Table.s;
v=DataS.Table.v;
a=DataS.Table.a;
dt=diff(t); dt(end+1)=dt(end);

Beginn={DataS.Beginn};
Ende={DataS.Ende};
Dauer={DataS.Dauer};
Phase={DataS.Phase};

g=9.81;
MPz=[0 .25 .50 1 1.75 2.75];
 vZ=[0 7 11 15 19]./3.6;       % alt
 aZ=[-10 -3 -2 -1 0 1 2 3];      % alt
% vZ=[0 0.1 2 4 5.4 6.9];         % men EHF
% aZ=[-10 -4 -3 -2 -1 0 1 2 3 4]; % men EHF
HFZ=[.5 .6 .7 .8 .9];

MP4=Norm.MP4(pos);                          
EC=Norm.EC0(pos);
KG=Norm.Gewicht(pos);
B1=find(MPz==1);
B4=MPz.*MP4;
LfdNr=Norm.LfdNr(pos);

RQ=0.96; kE=18.8+(21.1-18.8)*((RQ-0.7)/0.3);

%% EE/MP calculation

aES=a;                      % Korrektur von a für ES
logEs=abs(a)>4.415;     
aES(logEs)=sign(a(logEs))*4.415/g;
ES=aES/g;

EE=(155.4.*(ES).^5-30.4.*(ES).^4-43.3.*(ES).^3+ ...
        46.3.*(ES).^2+19.5.*ES+EC).*1.*((a.^2/g.^2)+1).^(1/2);

MP=EE.*v;
EEj=EE.*s;                  % globale Werte
EEkcal=EEj*KG/4184;         
Gesamtenergie=nansum(EEkcal);      
ED=nansum(EEj)/EC;
Gesamtdistanz=nansum(s);
EDI=ED/Gesamtdistanz;

MPmw=nanmean(MP);
EEjkg=nansum(EEj);

MPkj=MP/1000;              % J->kJ
MPVO2=(MPkj/kE)*1000;       % L->mL
MPVO2=MPVO2*60;             % s -> min
MPVO2(MPVO2<3.5)=3.5;
VO4=MP4/1000; VO4=(VO4/kE)*1000; VO4=VO4*60;
%% Histogram / Zones

[ZeitMpHist, DistanzMpHist, EnergieMpHist]=histo(MP,B4,ts,s,EEkcal);        % ändern für EHF
[ZeitVelHist, DistanzVelHist]=histo(v, vZ, ts, s);
[ZeitAccHist, DistanzAccHist]=histo(a, aZ, ts, s);

AvgVel=nanmean(v(v>=7/3.6));
% *100, Prozentwert JK
AnaeroberIndex=nansum(EnergieMpHist(:,B1:end))/Gesamtenergie;

%% Load calculation

LoadMp=sum(EnergieMpHist.*[0 0.5 1 2 3 4]);

%% Sprints

[Sprints_a, atp, adur]=sprintcalc(a,2.8,ts,0.6,0.21);
[Sprints_v, vtp, vdur]=sprintcalc(v,22/3.6,ts,0.6,0.21);
[Sprints_MP, Mtp, Mdur]=sprintcalc(MP,55,ts,0.6,0.21);

%% VO2 calculation

VO2Tn=VO2t(MPVO2,ts,35); % theor. VO2

%% Netto play time
try
[Netto,NetVec,Change,dur,v0r,LV]=NettoTime(DataS,Field,ts,20,5);
OutTimeMW=mean(dur);

if isnan(NetVec)
    MPmwNet=NaN;
    GesamtdistanzNet=NaN;
    GesamtenergieNet=NaN;     
    EDNet=NaN;
    EDINet=NaN;
    ZeitMpHistNet=NaN(size(ZeitMpHist));
    DistanzMpHistNet=NaN(size(DistanzMpHist));
    EnergieMpHistNet=NaN(size(EnergieMpHist));
    AnaeroberIndexNet=NaN;
else  
    MPmwNet=nanmean(MP(~NetVec));
    GesamtdistanzNet=nansum(s(~NetVec));
    GesamtenergieNet=nansum(EEkcal(~NetVec));     
    EDNet=nansum(EEj(~NetVec))/EC;
    EDINet=EDNet/GesamtdistanzNet;
    [ZeitMpHistNet, DistanzMpHistNet, EnergieMpHistNet]=histo(MP(~NetVec),B4,ts,s(~NetVec),EEkcal(~NetVec));
    AnaeroberIndexNet=nansum(EnergieMpHistNet(:,B1:end))/GesamtenergieNet;
end

NetFeatures=table(Netto, Change, OutTimeMW,GesamtdistanzNet,EDNet,EDINet,...
    GesamtenergieNet,AnaeroberIndexNet, MPmwNet, ...
    ZeitMpHistNet, DistanzMpHistNet, EnergieMpHistNet);

catch end

try
    Net=length(t)*0.066/60;
    %[Net,Vec,count,dur]=NettoEHF(DataS,ts,10,5)
    NetFeatures=table(Net);
catch end


%% Peaks

PeakVel=max(v);
PeakAccPos=max(a);
PeakAccNeg=min(a);
PeakMp=max(MP);

%% Heart Rate
try
HRrest=Norm.HRrest(pos);
HRmax=Norm.HRmax(pos);
aind=Norm.a(pos);    bind=Norm.b(pos);

agen=0.86;      bgen=1.67;
HF=DataS.Table.HF;
HF=fillmissing(HF,'linear');
HFmax=200;      %define ind. HFmax
iHFZ=HFZ*HFmax; 

[ZeitHfHist, ~]=histo(HF, iHFZ, ts, s);
AvgHf=nanmean(HF); 
SHRZ=sum(ZeitHfHist.*[1 2 3 4 5]);

dHR=(AvgHf-HRrest)/(HRmax-HRrest);
dt=numel(HF)*ts/60;

y=agen*exp(bgen*dHR);
TRIMP=dt*dHR*y;

cTRIMPgen=cTRIMP(HF,60,ts,HRrest,HRmax,agen,bgen);
cTRIMPind=cTRIMP(HF,60,ts,HRrest,HRmax,aind,bind);

PeakHf=max(HF);
IntExt=cTRIMPind/EEjkg;


HfFeatures=table(ZeitHfHist,AvgHf,PeakHf,SHRZ,TRIMP,cTRIMPgen,cTRIMPind,IntExt);
catch end
%% Export

Features=table(LfdNr,Phase,Beginn, Ende, Dauer, ...
    Gesamtdistanz,ED,EDI,Gesamtenergie,EEjkg,AnaeroberIndex,MPmw,MP4,VO4,...
    ZeitMpHist,DistanzMpHist,EnergieMpHist,...
    ZeitVelHist,DistanzVelHist,ZeitAccHist, DistanzAccHist,...
    Sprints_a,Sprints_v,Sprints_MP,...
    PeakVel,PeakAccPos,PeakAccNeg,PeakMp,...
    AvgVel,LoadMp,B1);


Features=[Str Features];

try Features=[Features NetFeatures]; catch end
try Features=[Features HfFeatures]; catch end
try Features=[Features DataS.AddDataRows]; catch end


Vecs=struct('LfdNr',LfdNr,'Vorname',Str.Vorname,'Nachname',Str.Nachname,'Phase',Phase,...
    'Mtp',Mtp,'Mdur',Mdur,'Zeit',t,...
    'Uhr',string(DataS.Table.clock),'VO2t',VO2Tn,'MP',MP);

try Vecs.lat=DataS.Table.lat; Vecs.lon=DataS.Table.lon; 
    Vecs.NetVec=NetVec; Vecs.v0r=v0r; Vecs.LV=LV; catch end
try Vecs.HF=HF; catch end



%%
if plotID==1
    
img=figure ('visible','off');
set(gcf, 'Position',  [100, 100, 1600, 1200])

subplot(3,1,1)
plot(v)
title('v [m/s]')

subplot(3,1,2)
plot(a)
title('a [m/s²]')

subplot(3,1,3)
plot(MP)
title('MP [W/kg]')

old=pwd;
cd('C:\Users\schaertb\OneDrive - rub.de\Documents\Lehrstuhl\MetPow\3_EHF\Plots')
exportgraphics(img,strcat(Str.Einheit{1}," ",Str.Nachname{1},".png"))
cd(old)
close(gcf)
end
