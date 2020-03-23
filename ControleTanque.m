clc
clearvars global
close all

kp=1;
ki=0.02;
kd=1.2;
%Kp=kp;
%Ki=Kp*Ts/Ti;
%Kd=Kp*Td/Ts;

%Parâmetros Iniciais

% u=0;
santerior = 0; %soma anterior
eanterior = 0; %erro anterior
erroq = 0;     %erro quadrático
k = 2;         %Valor de K inicial
a = 0.6;       %Índice a
b = 0.4;       %Índice b
ur = 0;
su = 0;
seq=0;
%Ts = %tempo de amostragem
%Ti = %tempo do integrador
%Td = %tempo do derivativo

%Valores Kp, Ki, Kd


%Realocação de Memória

y=zeros(1,4000);
ref=zeros(1,4000);
T=zeros(1,4000);
tempo=zeros(1,4000);

tic;
tempo(1)=0;

%Loop de Controle por 60 s
while (tempo(k-1)<60)     
   [nivel1,nivel2,nivel3,yr]=LerURL('http://192.168.1.3/');  
   
   %Cálculo do erro
   
   yr = 15;
   e = yr-nivel1;
   erroq = e^2;
   seq = seq+erroq;
   s = santerior + e;
   de = e-eanterior;
   
   %PID
   
   u =kp*e+ki*s+ kd*de;
   %u=Kp*e+Ki*s+Kd*de; %PID discreto
     
   %Limites de Tensão da Bomba
   
   if (u > 5)
       
       u = 5;
   end
   
   if (u < 0)
        
       u = 0;
   end
   
     
   %Indice de Desempenho da Bomba
   
   ur = u^2;
   su = su + ur;
   pwm=u*51;
   pwm=round(pwm);
   
   EscreverURL('http://192.168.1.3/?tensao=',pwm)
   
 %Limite de Transbordamento
   
      if(nivel1 > 25)
          u = 0;
       
      end
 
 %Recebimento de Valores para o Próximo Loop
 
 santerior = s;
 eanterior = e;
 clc;

 %Mostra as Variáveis
 
 disp(['Nivel do tanque: ' ,num2str(nivel1)])
 disp(['Nivel de referência: ' ,num2str(yr)])
 disp(['Tensão de ref Arduino: ' ,num2str(pwm/51)]) % CONVERTE O VALOR DE 0 A 255 PARA 0 A 5!
 
 %clc;
 
 tempo (k)=toc;
 disp(['Tempo(s): ' ,num2str(tempo(k))]) 
 y(k) = nivel1;
 ref(k) = yr;
 T(k)=pwm/51;
 %tempo (k)=2;
 k = k+1;

end


%Índices de Desempenho

EscreverURL('http://192.168.1.3/?tensao=',0);
plot(tempo,y);
hold on;
plot(tempo,ref,'--r');
figure;
plot(tempo,T);
hold on;

emq = seq/k;
Vmedio = su/k;

indice = a*emq + b*Vmedio;
disp(['Índice de Desempenho: ' ,num2str(indice)])