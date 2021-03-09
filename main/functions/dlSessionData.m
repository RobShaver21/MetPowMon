function dlSessionData(AllSessions,M,DataF)

players=M.players;
teamurl=M.teamurl;
datarequest=M.datarequest;

%%
failure = struct('player_id', {},'player_session_id', {},'session_id', {}, 'err', {});

outvarnames={'ID','Nachname','Vorname','SpielerNr','Beginn','Ende','markers','Daten'};

c=cell(size(outvarnames))';
a=1; ply=1;
%%
for a=1:length(AllSessions)
    %% GET session participants
    Dout=cell2struct(c,outvarnames);
    
    session_id=AllSessions(a).id;
    
    teamsessionurl=[teamurl 'training_sessions/' session_id];
    session_detail=send(datarequest,teamsessionurl);
    
    participants=session_detail.Body.Data.data.participants;

    datum=datetime(AllSessions(a).start_time,...
        'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss');
        
    %% Player-Loop
    for ply=1:length(participants)
        try
            
            %% GET player training session
            player_id=participants(ply).player_id;
            player_session_id=session_detail.Body.Data.data.participants(ply).player_session_id;
            %%  Extract sample-data
            sampleurl=[...
                'https://teampro.api.polar.com/v1/training_sessions/' ...
                player_session_id '/?samples=all'];
            sampleresponse=send(datarequest, sampleurl);
            %% Generate Output

            Dout(ply).ID=player_id;
            
            sensor_data=[sampleresponse.Body.Data.data.samples.values{:,:}]';
            sensor_name=[sampleresponse.Body.Data.data.samples.fields];
            
            ind=cellfun(@isempty,sensor_data);
            sensor_data(ind)={nan};
            
            ind = cellfun(@(c) ischar(c) && ~isempty(strfind(c, 'NaN')), sensor_data);
            sensor_data(ind)={nan};
            
            T=cell2table(sensor_data);
            T.Properties.VariableNames=sensor_name;
            
            t=[0:seconds(0.1):seconds((height(T)-1)/10)]';
            T.t=t;
            T.time=[];
            TT=table2timetable(T);
            
            Dout(ply).Daten=TT;
            
            index=strcmp(player_id,{players.player_id});
            
            if sum(index) > 0
                Dout(ply).Nachname=players(index).last_name;
                Dout(ply).Vorname=players(index).first_name;
                Dout(ply).SpielerNr=players(index).player_number;
            else
                Dout(ply).SpielerNr=player_id;
                Dout(ply).Vorname=player_id;
                Dout(ply).Nachname=player_id;
            end
            
            
            sampling_start=datetime(sampleresponse.Body.Data.data.start_time,...
                'InputFormat', 'uuuu-MM-dd''T''HH:mm:ss');
            sampling_start.Format='HH:mm:ss.S';
            
            Dout(ply).Daten.clock=Dout(ply).Daten.t+sampling_start;
            Dout(ply).Beginn=AllSessions(a).start_time;
            Dout(ply).Ende=AllSessions(a).end_time;
            Dout(ply).markers=session_detail.Body.Data.data.markers;
            
            % add Polar Data 
            % GET /v1/teams/training_sessions/{training_session_id}
        catch ME
            failure(end + 1).player_id = player_id;
            failure(end).player_session_id = player_session_id;
            failure(end).session_id = session_id;
            failure(end).err  = getReport(ME);
        end 
    end
    
    % save Output
    if ~isempty(Dout.Daten)
        filename=[char(DataF) '\' datestr(datum,'yyyymmdd_HHMMSS'),'.mat'];
        save (filename,'Dout');
    end
    
end

% save error log

errorLog(DataF, failure);

end
