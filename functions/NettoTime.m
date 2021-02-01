 function [Net,Vec,count,dur,v0r,LV]=NettoTime(DataS,Field,ts,t1,t2)
Net=NaN(1);
Vec=NaN(1);
count=NaN(1);
dur=NaN(1);
v0r=NaN(1);
LV=NaN(1);
%%
lat=DataS.Table.lat;
lon=DataS.Table.lon;
mlat=nanmean(lat);
mlon=nanmean(lon);

for a=1:length(Field)
    mi(:,a)=min(Field(a).P,[],2)-0.001;
    ma(:,a)=max(Field(a).P,[],2)+0.001;
end

IdLat=mi(1,:)<mlat & mlat<ma(1,:);
IdLon=mi(2,:)<mlon & mlon<ma(2,:);
Id=IdLat & IdLon;

if sum(Id)==1
    % calculate in vector v0
    pos=find(Id==1);
    P=Field(pos).P;
    P0=P(:,1);
    P1=P(:,2);
    P2=P(:,3);
    T=Field(pos).T;
    
    Lat0=lat-P0(1);                 % set left corner as reference
    Lon0=lon-P0(2);
    v=[Lat0';Lon0'];                  % coordinates to transformate
    v0=v;
    for a=1:length(v)               % transformation
        v0(:,a)=T*v(:,a);
    end
    
    % calculate vector after base change v0r
    arclenV1=distance(P0(1),P0(2),P1(1),P1(2));
    arclenV2=distance(P0(1),P0(2),P2(1),P2(2));
    LV1=deg2km(arclenV1)*1000;  %length Vector 1 in [m]
    LV2=deg2km(arclenV2)*1000;  %length Vector 2 in [m]
    LV=[LV1 LV2];
    v0r=v0.*[LV1;LV2];
    
    % calculate in-time
    log=v0>1|v0<0;              % in-field vector
    slog=log(1,:)+log(2,:);
    slog=(slog>=1)';
    
    
    
    mw=movmean(slog,1/ts);
    Vec=mw>=0.05;      % 0.1 * 1/2
    
    if exist('t2','var')
        mw=movmean(mw,1.5*t2/ts);
        Vec=mw>=0.03;
    end

    transitions = diff([false; Vec; false]);
    inrangestarts = find(transitions == 1);
    inrangeends = find(transitions == -1);
    count = length(inrangeends);
    inrangeduration = (inrangeends - inrangestarts)*ts;
    dur=inrangeduration;
    
    id=inrangeduration<t1;
    v1=inrangestarts(id);
    v2=inrangeends(id);
    
    try
    v3=v1(1);
    
    for b=1:length(v1)   
    v3=[v3; (v1(b):v2(b))'];
    end
    
    Vec(v3)=0;
    Vec=Vec(1:length(DataS.Table.t));
    inrangestarts(id)=[];
    inrangeends(id)=[];
    inrangeduration(id)=[];
    dur=inrangeduration;
    
    catch
    end
    
    Net=(length(Vec)-sum(Vec))*ts/60;      % Format
    
    %% Plots 
    
    
    figure('visible','off')
    hold on
    plot (slog)
    plot(mw)
    plot(Vec)
    b=num2str(inrangeduration);
    c=cellstr(b);
    try
    text(inrangestarts,ones(size(c))+0.1,c,'Fontsize',6)
    catch end
    ylim([0,1.2])
    old=pwd;
    cd(['C:\Users\' getenv('username') '\OneDrive - rub.de\Documents\Lehrstuhl\MetPow\2_Hockey\NettoPlot'])
    saveas(gcf,[DataS.Phase ' ' DataS.Name ' ' DataS.Einheit '_Netto.png'])
    close(gcf)
    
    figure('visible','off')
    lat=lat(~isnan(lat));
    lon=lon(~isnan(lon));
    geoplot(lat,lon)
    geobasemap satellite
    hold on
    axlat=[P(1,2) P(1,1) P(1,3)];
    axlon=[P(2,2) P(2,1) P(2,3)];
    geoplot(axlat,axlon);
    hold off
    saveas(gcf,[DataS.Phase ' ' DataS.Name ' ' DataS.Einheit '_Satellite.png'])
    close(gcf)
    
    figure('visible','off')
    log=or(~isnan(v0r(2,:)),~isnan(v0r(1,:)));
    pv0r=[v0r(1,log);v0r(2,log)];
    plot(pv0r(2,:),pv0r(1,:))
    daspect([1 1 1])
    HockeyField(LV1,LV2)
    saveas(gcf,[DataS.Phase ' ' DataS.Name ' ' DataS.Einheit '_T.png'])
    close(gcf)
   
end

end
