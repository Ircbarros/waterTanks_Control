%A url deve ser passada no formato string e o valor nos padrões arduino
%0-255
function EscreverURL(url,valor)
    URL = [url num2str(valor)];
    filename = 'samples.html';
    urlwrite(URL,filename,'get',{'term','urlwrite'});
end