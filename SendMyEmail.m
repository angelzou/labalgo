function SendMyEmail(content)
% ���÷����ʼ������ã�������gmail����
mail = 'olenet@126.com'; %gmail��ַ��qq,163Ҳ���Ե�
password = 'gits@126.com';  %��������

%������gmail�ı�׼���ã��������䣬������Ӧ�޸�
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.126.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

% �����ʼ�

subject = '������';
content = '����ޱ���'
for i=1:10
    sendmail('17789917@qq.com',subject, content);
    pause(10);
end
%% ���͸���ʾ��
% sendmail('17789917@qq.com',subject, content, ��������);
% a = rand(100);
% DataPath = [matlabroot,filesep,'mydata.mat'];
% save(DataPath,'a');
% sendmail('�ռ��˵�ַ',subject,content,DataPath);

end