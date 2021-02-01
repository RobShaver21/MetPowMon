function [data]=AddGpx(data)
G=dir('*.gpx');                 % N <- Dateien der Spieler
G={G.name};

%% Test

% fid=fopen(G{1},'r');
% 
% 
% k=1;
% while(1)
%     line=fgetl(fid);
%     if ~ischar(line), break, end
%     if(numel(line)<10),continue,
%     elseif(line(10)=='v')
%         vector(k,:)=sscanf(line,'%*s%*s%*s%*s x="%f" y="%f"',[1 2]);
%         k=k+1;
%     end
% end
% 
% x=vector(:,1);
% y=vector(:,2);
% 
% fclose(fid);
% 
% 
% DOM=xmlread(G{1});
% x_root = DOM.getFirstChild;
% trkpt_nodes = x_root.getElementsByTagName('trkpt');
% time_nodes = x_root.getElementsByTagName('time');
% 
% lon=NaN(trkpt_nodes.getLength);
% lat=NaN(size(lon));
% time=NaN(size(lon));
% 
% for i = 0 : trkpt_nodes.getLength - 1
%    trkpt_element = trkpt_nodes.item(i);
%    lat(i+1)=trkpt_element.getAttribute('lat');
%    lon(i+1)=trkpt_element.getAttribute('lon');
%    time_element = time_nodes.item(i);
%    time(i+1)=time_element.getAttribute('time');
% end

%%

DOM=xmlread(G{1});
GPX=xml2struct(DOM);

time=strings(size(GPX.gpx.trk.trkseg.trkpt))';   % preallocation
lat=strings(size(time));
lon=strings(size(time));
for b=1:length(GPX.gpx.trk.trkseg.trkpt)     % extract time
    time(b)=GPX.gpx.trk.trkseg.trkpt{1,b}.time.Text;
    lat(b)=GPX.gpx.trk.trkseg.trkpt{1,b}.Attributes.lat;
    lon(b)=GPX.gpx.trk.trkseg.trkpt{1,b}.Attributes.lon;
end

lat=str2double(lat);
lon=str2double(lon);

time=extractAfter(time,'T');
time=extractBefore(time,'Z');
dur=NaT(size(time)) - NaT(1);

for c=1:length(time)        % convert to duration-array
    dur(c)=duration(str2double(strsplit(time(c), ':')));
end

dtime=data.clock(1)-dur(1);
dur=dur+dtime;

try
    tpS = arrayfun(@(x) find(data.clock>=x,1,'first'),dur); %find in table
    data.lat=NaN(height(data),1);
    data.lon=NaN(height(data),1);
    data.lat(tpS)=lat;              % allocate data to table
    data.lon(tpS)=lon;
    check=1;
catch
end


try
    if ~exist('check','var')
        tpS = arrayfun(@(x) find(data.clock>=x,1,'first'),dur,'UniformOutput',false);
        tpS=cell2mat(tpS);
        tpS(end+1)=tpS(end);
        data.lat=NaN(height(data),1);
        data.lon=NaN(height(data),1);
        data.lat(tpS)=lat;              % allocate data to table
        data.lon(tpS)=lon;
    end
    
catch
end
end
