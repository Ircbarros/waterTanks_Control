%A url deve ser passada no formato string e o nivel ser� retornado no
%formato float

function [nivel1,nivel2,nivel3,yr]=LerURL(url)
%url = 'http://192.168.1.105/';
str = urlread(url,'Get',{'term','urlread'});
%x=strfind(str,'/b>');
nivel1=str2num(str(46:50));
nivel2=str2num(str(67:71));
nivel3=str2num(str(88:92));
yr=str2num(str(106:end));
%nivel=str2num(str(45:end));
end