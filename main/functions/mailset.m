function []=mailpref(Mail)
    setpref('Internet','SMTP_Server', Mail.SMTP);
    setpref('Internet','E_mail', Mail.Email);
    setpref('Internet','SMTP_Username', Mail.Username);
    setpref('Internet','SMTP_Password',Mail.PW);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port',Mail.Port);
end
