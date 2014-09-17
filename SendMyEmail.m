function SendMyEmail(content)
% 设置发送邮件的配置，我们用gmail举例
mail = 'olenet@126.com'; %gmail地址，qq,163也可以的
password = 'gits@126.com';  %邮箱密码

%下面是gmail的标准配置，其他邮箱，可以相应修改
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.126.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% 发送邮件

subject = '程序结果';
content = '邹玉薇你好'
for i=1:10
    sendmail('17789917@qq.com',subject, content);
    pause(10);
end
%% 发送附件示例
% sendmail('17789917@qq.com',subject, content, 附件参数);
% a = rand(100);
% DataPath = [matlabroot,filesep,'mydata.mat'];
% save(DataPath,'a');
% sendmail('收件人地址',subject,content,DataPath);

end