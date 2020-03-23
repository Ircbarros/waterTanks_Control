%A url deve ser passada no formato string e o nivel será retornado no
%formato float

function [nivel3,yr]=LerURL(url)
%url = 'http://192.168.1.105/';
str = urlread(url,'Get',{'term','urlread'});
%x=strfind(str,'/b>');
nivel3=str2num(str(88:93));
yr=str2num(str(106:end));
%nivel=str2num(str(45:end));
end