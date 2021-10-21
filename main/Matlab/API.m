clearvars; close all; clc;

%% Settings
% 1=VFL 2=Hockey 3=EHF 4=HoNaMa 5=API_HoNaMa 6=API_Dana 7=API_DanaU21 8=API_eagle
ProfileId=3;               
loadSettings()

%% import
import matlab.net.*
import matlab.net.http.*

%% Authorization

access_token=authorizePolar;

%% get Sessions

[AllSessions, M]=getSessions(P.api,access_token);

%% Pick sessions

Pick=[1];
AllSessions=AllSessions(Pick);

% ind=strcmp(AllSessions.type,'TRAINING');
% AllSessions=AllSessions(ind);

%% Session Loop

dlSessionData(AllSessions,M,P.Datafolder);
