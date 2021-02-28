function [NewData]=convertdata(data,P)

ID=P.SourceId;
source=P.Source;

%% Polar CSV
if ID==1
    t=data{:,source.t};
    t=seconds(t);
    HR=data{:,source.HR};
    v=data{:,source.v};
    v=v/3.6;
    s=diff(data{:,source.s});
    s(end+1)=0;
    a=data{:,source.a};
    clock=data{:,source.clock};
    NewData=table(t,clock,s,v,a,HR);
    
    %% Polar API
elseif ID==3
    select=[5:11];
    VarNames=source.Properties.VariableNames;
    VarNames=VarNames(select);
    val=[source{1,select}];
    % Header=VarNames(val);
    data.Properties.VariableNames(val)=VarNames;
    data.s=gradient(data.s);
    data.v=data.v/3.6;
    [NewData id] = fillmissing(data,'previous','MaxGap',seconds(2));
    %% Kinexon
elseif ID==4
     fs=P.Source.ts;
     
    fs=0.066;
    
    x=data.xInM;
    y=data.yInM;
    clock=data.formattedLocalTime;
    T=table(clock,x,y);
    id=isnan(T.x);
    T(id,:)=[];
    T=table2timetable(T);
    %T=retime(T,'regular','linear','TimeStep',seconds(fs));
    T.t=seconds(T.clock-T.clock(1));
    dt=gradient(T.t-T.t(1));

    % filter
    fcv = 1;
    fca=0.5;
    t=1/fs;
    
    [bv,av] = butter(3,fcv/(t/2));
    [ba,aa] = butter(3,fca/(t/2));

    dx=gradient(T.x);
    dy=gradient(T.y);
    s=sqrt(dx.^2+dy.^2);
    v=s./dt;
    v=filtfilt(bv,av,v); 
    a=gradient(v)./dt;
    a=filtfilt(ba,aa,a);
    
    T.a=a;
    T.v=v;
    T.s=s;
    
    NewData=T;
         
%     figure
%     tiledlayout(3,1)
%     nexttile
%     plot(cumsum(s))
%     nexttile
%     plot(v)
%     nexttile
%     plot(a)
%     sum(s)
 

   end 
    

end



