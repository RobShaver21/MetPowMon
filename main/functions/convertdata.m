function [NewData]=convertdata(data,varset,ID)

%% Polar CSV
if ID==1
    t=data{:,varset.t};
    t=seconds(t);
    HR=data{:,varset.HR};
    v=data{:,varset.v};
    v=v/3.6;
    s=diff(data{:,varset.s});
    s(end+1)=0;
    a=data{:,varset.a};
    clock=data{:,varset.clock};
    NewData=table(t,clock,s,v,a,HR);
    
    %% Polar API
elseif ID==3
    select=[5:11];
    VarNames=varset.Properties.VariableNames;
    VarNames=VarNames(select);
    val=[varset{1,select}];
    % Header=VarNames(val);
    data.Properties.VariableNames(val)=VarNames;
    data.s=gradient(data.s);
    data.v=data.v/3.6;
    [NewData id] = fillmissing(data,'previous','MaxGap',seconds(2));
    %% Kinexon
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
    

end



