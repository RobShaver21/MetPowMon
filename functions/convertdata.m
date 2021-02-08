function [NewData]=convertdata(data,varset,ID)

%% Polar CSV
if ID==1
    t=data{:,varset.t};
    t=seconds(t);
    HF=data{:,varset.HR};
    v=data{:,varset.v};
    v=v/3.6;
    s=diff(data{:,varset.s});
    s(end+1)=0;
    a=data{:,varset.a};
    clock=data{:,varset.clock};
    NewData=table(t,clock,s,v,a,HF);
    
    %% Polar API
elseif ID==3
    select=[5:11];
    VarNames=varset.Properties.VariableNames;
    VarNames=VarNames(select);
    val=[varset{1,select}]
    % Header=VarNames(val);
    data.Properties.VariableNames(val)=VarNames;
    [data id] = fillmissing(data,'previous','MaxGap',20);
    %% Kinexxon
elseif ID==4
    
    % filter
    fcv = 1;
    fca=0.5;
    fs = 15.15;
    [bv,av] = butter(3,fcv/(fs/2));
    [ba,aa] = butter(3,fca/(fs/2));
    
    log=~isnan(data{:,varset.x});   % select LPS values only
    x=data{log,varset.x};
    y=data{log,varset.y};
    
    t=data{log,varset.t};
    t=(t-t(1))/1000;                % ms -> s
    clock=data{log,varset.clock};
    % calculate s,v,a
    dx=diff(x);
    dy=diff(y);
    dt=diff(t);
    dt(end+1)=dt(end);
    s=sqrt(dx.^2+dy.^2);
    s(end+1)=0;
    v=s./dt;
    v=filtfilt(bv,av,v);            % filter v
    
    dv=diff(v);
    dv(end+1)=dv(end);
    a=dv./dt;
    a=filtfilt(ba,aa,a);            % filter a
    
    NewData=table(t,clock,s,v,a,x,y);
   end 
    %%
    
    % Positionen filtern?
    %     xf=filtfilt(bv,av,x);
    %     yf=filtfilt(bv,av,y);
    %     %sf=filtfilt(bv,av,s);
    
    
    
    % delete
    %     figure
    %     tiledlayout(2,2)
    %     nexttile
    %     plot(x)
    %     title('x')
    %     nexttile
    %     plot(y)
    %     title('y')
    %     nexttile
    %     plot(xf)
    %     title('xf')
    %     nexttile
    %     plot(yf)
    %     title('yf')
    %
    %     dx=diff(x);
    %     dy=diff(y);
    %     dt=diff(t);
    %     dt(end+1)=dt(end);
    %     dxf=diff(xf);
    %     dyf=diff(yf);
    %
    %     s=sqrt(dx.^2+dy.^2);
    %     s(end+1)=0;
    %     sf=sqrt(dxf.^2+dyf.^2);
    %     sf(end+1)=0;
    %     v=s./dt;
    %     vf=sf./dt;
    %
    %     vB=filtfilt(bv,av,v);
    %     vBf=filtfilt(bv,av,vf);
    %
    %     figure
    %     tiledlayout(2,2)
    %     nexttile
    %     plot(v)
    %     title('v')
    %     nexttile
    %     plot(vf)
    %     title('vf')
    %     nexttile
    %     plot(vB)
    %     title('vB')
    %     nexttile
    %     plot(vBf)
    %     title('vBf')
    %
    %     sV=v.*dt;
    %     sVB=vB.*dt;
    %
    %     figure
    %     tiledlayout(2,1)
    %     nexttile
    %     plot(sV)
    %     title('sV')
    %     nexttile
    %     plot(sVB)
    %     title('sVB')
    %
    %     sum(sV)
    %
    %     sum(sVB)
    %
    %     sum(s)
    %     sum(sf)
    
    %% plausibilty plots - remove later
    %     old=pwd;
    %     cd
    
    % img=figure('visible','off')
    %
    % subplot(3,1,1)
    % plot(v)
    % title('v [m/s]')
    %
    % subplot(4,1,2)
    % plot(v1)
    % title('v [m/s] butter 1hz')
    %
    % subplot(4,1,3)
    % plot(a)
    % title('a [m/s²] raw (velocity filtered)')
    %
    % subplot(4,1,4)
    % plot(a2)
    % title('a [m/s²] butter 0.5hz')
    
    

end



