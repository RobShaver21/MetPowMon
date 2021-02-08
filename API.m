clearvars; close all; clc;

%% Settings

ProfileId=4;        % 1=VFL 2=Hockey 3=EHF 4=HoNaMa

loadSettings()

%% import
import matlab.net.*
import matlab.net.http.*

%% Authorization

if isfile('auth.mat')
    load auth.mat
end

% load client id & secret
load client.mat

access_token=authorizePolar(client,refresh_token);

% redirect_uri='http://localhost:5000/oauth2_callback';
%% GET Teams

teammethod='GET';
teamheader = matlab.net.http.HeaderField(...
    'Accept','application/json',...
    'Authorization', ['Bearer ', access_token]...
    );

teamurl='https://teampro.api.polar.com/v1/teams/';

datarequest=matlab.net.http.RequestMessage(teammethod,teamheader);
teamresponse=send(datarequest,teamurl);

%% select team
%HoNaMas = 1, Danas Hockey = 2, Danas U21 = 3, Eagles = 4
profile=1;
team_id=teamresponse.Body.Data.data;
team_select=team_id(profile).id;
%% Get team details

detailurl=[teamurl team_select];
detailresponse=send(datarequest,detailurl);
% Players of team, including staff
players=detailresponse.Body.Data.data.players;
%% Get team training Sessions

NrPage=0;
NrPerPage=100;
paginationQuery=['?page=' num2str(NrPage) '&per_page=', num2str(NrPerPage)];
perpage='?per_page=100';

teamsessionsurl=[teamurl team_select '/training_sessions'];
teamsessionresponse=send(datarequest,[teamsessionsurl, paginationQuery]);
NrPages=teamsessionresponse.Body.Data.page.total_pages;

AllSessions=teamsessionresponse.Body.Data.data;
for i=1:NrPages-1
    NrPage=num2str(i);
    paginationQuery=['?page=' num2str(NrPage) '&per_page=', num2str(NrPerPage)];
    AppSessionsResponse=send(datarequest,[teamsessionsurl, paginationQuery]);
    AllSessions=[AllSessions; AppSessionsResponse.Body.Data.data];
end


% remove empty fields, get session id
% teamsessions=teamsessionresponse.Body.Data.data(...
%     ~isempty(teamsessionresponse.Body.Data.data.name));

%% Pick sessions

Pick=[1:5];
AllSessions=AllSessions(Pick);

% ind=strcmp(AllSessions.type,'TRAINING');
% AllSessions=AllSessions(ind);

%% Session Loop

dlSessionData(AllSessions,player_id,teamurl,datarequest);

