clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=7;               
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

%% get Sessions

[AllSessions, M]=getSessions(P.GameId,access_token);

%% Pick sessions

Pick=[1:2];
AllSessions=AllSessions(Pick);

% ind=strcmp(AllSessions.type,'TRAINING');
% AllSessions=AllSessions(ind);

%% Session Loop

dlSessionData(AllSessions,M,P.Datafolder);
