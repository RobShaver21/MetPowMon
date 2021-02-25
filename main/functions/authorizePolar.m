function access_token=authorizePolar

if isfile('auth.mat')
    load auth.mat
end

load client.mat       % load client id & secret

% Checks if refresh_token was issued for refresh_token-flow -> no code needed
if exist('refresh_token','var')==1
    method='POST';
    auth=['Basic ' matlab.net.base64encode([client.id ':' client.secret])];
    Content_Type='application/x-www-form-urlencoded';
    data = ['grant_type=refresh_token&refresh_token=', refresh_token];
    header=matlab.net.http.HeaderField(...
        'Authorization',auth,...
        'Content-Type',Content_Type...
        );
    request = matlab.net.http.RequestMessage(method,header,data);
    uri = matlab.net.URI('https://auth.polar.com/oauth/token');
    response=send(request,uri);
    
elseif exist('refresh_token','var')==0 || response.StatusCode ~=200
 % If not successful or first time
 % URL redirects back to authorization callback domain with code valid for 12 h
 
    url=['https://auth.polar.com/oauth/authorize?client.id='...
        client.id '&response_type=code&scope=team_read'];
    web(url);
    answer = inputdlg('Enter Code','Input');
    code=char(answer);
    %Send Post request for token
    data = ['grant_type=authorization_code&code=', code];
    request = matlab.net.http.RequestMessage(method,header,data);
    response=send(request,uri);
    refresh_token=response.Body.Data.refresh_token;
end

access_token=response.Body.Data.access_token;
save('auth.mat','refresh_token');
end
