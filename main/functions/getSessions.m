function [AllSessions, M]=getSessions(PolarTeamId,access_token);

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



%% struct for export

M.players=players;
M.teamurl=teamurl;
M.datarequest=datarequest
