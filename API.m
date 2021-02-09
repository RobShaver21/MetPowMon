clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=6;               
loadSettings()

%% import
import matlab.net.*
import matlab.net.http.*

%% Authorization
if isfile('auth.mat')
    load auth.mat
end

load client.mat       % load client id & secret
access_token=authorizePolar(client,refresh_token);

% redirect_uri='http://localhost:5000/oauth2_callback';
%% GET Teams

teamurl='https://teampro.api.polar.com/v1/teams/';
teammethod='GET';
teamheader = matlab.net.http.HeaderField(...
    'Accept','application/json',...
    'Authorization', ['Bearer ', access_token]...
    );
datarequest=matlab.net.http.RequestMessage(teammethod,teamheader);
teamresponse=send(datarequest,teamurl);

%% select team

PolarTeamId=GameId;
team_id=teamresponse.Body.Data.data;
team_select=team_id(PolarTeamId).id;

%% GET team details

detailurl=[teamurl team_select];
detailresponse=send(datarequest,detailurl);
players=detailresponse.Body.Data.data.players;

%% GET team training Sessions

NrPage=0;
NrPerPage=100;
paginationQuery=['?page=' num2str(NrPage) '&per_page=', num2str(NrPerPage)];

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

% Pick=[1:5];
% AllSessions=AllSessions(Pick);

% ind=strcmp(AllSessions.type,'TRAINING');
% AllSessions=AllSessions(ind);

%% Session Loop

dlSessionData(AllSessions,players,teamurl,datarequest,DataF);
