%A url deve ser passada no formato string e o nivel será retornado no
%formato float

function [nivel1,nivel2,nivel3,yr]=LerURL(url)

str = urlread(url,'Get',{'term','urlread'});

nivel1=str2num(str(46:50));
nivel2=str2num(str(67:71));
nivel3=str2num(str(88:92));
yr=str2num(str(106:end));

end