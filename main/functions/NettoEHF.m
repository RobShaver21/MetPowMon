function [Net,Vec,count,dur]=NettoEHF(DataS,t1,t2)

    x=DataS.Table.x;
    y=DataS.Table.y;
    t=DataS.Table.t;
    tmin=t/60;
    ts=t(2)-t(1);
   
    slog=abs(x)>20|abs(y)>10;

    mw=movmean(slog,floor(1/ts));
    Vec=mw>=0.05;      % 0.1 * 1/2
    
%     figure
%     hold on
%     plot(t,Vec)
%     plot(t,slog)
%     plot(t,mw)
%     legend
%     
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
    
    v3=unique(v3);
    Vec(v3)=0;
    Vec=Vec(1:length(DataS.Table.t));
    inrangestarts(id)=[];
    inrangeends(id)=[];
    inrangeduration(id)=[];
    dur=inrangeduration;
    
    catch
    end
    
    Net=(length(Vec)-sum(Vec))*ts/60;      % Format