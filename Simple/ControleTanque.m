clc
clearvars global
close all

kp=0.846; %0.23
ki=0.028; %0.01
kd=0.07;  %0.27
%Para 5 cm
    %Kp=0.511028, Ki=0.039204. Kd=0.632571
%Para 10 cm
    %%Kp=0.228706, Ki=0.014779, Kd=0.265664
%Para 15 cm
    %Kp=0.198207 , Ki=0.0165 , Kd=0.204472;
%Para 20 cm
    %%Kp=0,141547, Ki=0,010659, Kd=0,169403

%Par�metros Iniciais

% u=0;
santerior = 0; %soma anterior
eanterior = 0; %erro anterior
erroq = 0;     %erro quadr�tico
k = 2;         %Valor de K inicial
a = 0.4;       %�ndice a
b = 0.6;       %�ndice b
ur = 0;
su = 0;
seq=0;
amost=0.4;


%Valores Kp, Ki, Kd


%Realoca��o de Mem�ria

y=zeros(1,120);
ref=zeros(1,120);
T=zeros(1,120);
tempo=zeros(1,120);


tempo(1)=0;
tic;
%Loop de Controle por 100 s
while (tempo(k-1)<100)     
   [nivel1,nivel2,nivel3,yr]=LerURL('http://192.168.1.3/');   
   
 if(tempo(k-1)>0 && tempo(k-1)<25)
     yr=5;
 end
 
 if(tempo(k-1)>25 && tempo(k-1)<50)
     yr=15;
 end
 
 if(tempo(k-1)>50 && tempo(k-1)<75)
     yr=8;
 end
 
 if(tempo(k-1)>75 && tempo(k-1)<100)
     yr=20;
 end
 
 if(tempo(k-1)>100 && tempo(k-1)<125)
     yr=13;
 end
 
   %C�lculo do erro
   e = yr-nivel1;
   erroq = e^2;
   seq = seq+erroq;
   s = santerior + e;
   de = e-eanterior;
   
   %PID
   
   u =kp*e+ki*s+ kd*de;

     
   %Limites de Tens�o da Bomba
   
   if (u>5)
       
       u=5;
   end
   
   if (u<0)
        
       u=0;
   end
   
     
   %Indice de Desempenho da Bomba
   
   ur = u^2;
   su = su + ur;
  
   %PWM Bomba
   pwm=u*51;
   pwm=round(pwm);
   EscreverURL('http://192.168.1.3/?tensao=',pwm)
   
 %Limite de Transbordamento
   
      if(nivel1>27)
          u=0;
       
      end
 
 %Recebimento de Valores para o Pr�ximo Loop
 
 santerior = s;
 eanterior = e;
 clc;

 %Mostra as Vari�veis
 
 disp(['Nivel do tanque: ' ,num2str(nivel1)])
 disp(['Nivel de refer�ncia: ' ,num2str(yr)])
 disp(['Tens�o na Bomba: ' ,num2str(pwm/51*3)]) % CONVERTE O VALOR DE 0 A 255 PARA 0 A 5!
 
 %clc;
 
 y(k) = nivel1;
 ref(k) = yr;
 T(k)=pwm/51;
 tempo(k)=toc;
 pause(amost-(tempo(k)-tempo(k-1)));
 disp(['Tempo(s): ' ,num2str(tempo(k))]) 
 k = k+1;

end


%PLOT

EscreverURL('http://192.168.1.3/?tensao=',0);
plot(tempo,y);
hold on;
plot(tempo,ref,'--r');
figure;
plot(tempo,T);

%�ndices de Desempenho
emq = seq/k;
Vmedio = su/k;

indice = a*emq + b*Vmedio;
disp(['�ndice de Desempenho: ' ,num2str(indice)])