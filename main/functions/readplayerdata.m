function [t,s,v,a,HF]=convertdata(data,varset)

if varset.ID{1}==5
    t=data{:,varset.t};
    t=seconds(t);
    HF=data{:,varset.HR};
    v=data{:,varset.v};
    v=v/3.6;
    v=table2array(data(:,4));
    v=v/3.6;
    s=diff(data{:,varset.s});
    s(end+1)=0;
    a=data{:,varset.a};
end
end


