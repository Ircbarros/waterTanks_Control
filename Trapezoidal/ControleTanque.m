clc
clearvars global
close all

kp=0.846; %0.23
ki=0.008; %0.01
kd=0;  %0.27

%Parâmetros Iniciais

santerior = 0; %soma anterior
eanterior = 0; %erro anterior
erroq = 0;     %erro quadrático
k = 2;         %Valor de K inicial
a = 0.4;       %Índice a
b = 0.6;       %Índice b
ur = 0;
su = 0;
seq=0;

%Regressão Polin. Tanque Trapezoidal
[p,s]=polyfit([50,62,78,94,111,127,146,164,182,199,218,233,250,268,284,300],[0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30],1);
amost=0.45;


%Valores Kp, Ki, Kd


%Realocação de Memória

y=zeros(1,120);
ref=zeros(1,120);
T=zeros(1,120);
tempo=zeros(1,120);


tempo(1)=0;
tic;
%Loop de Controle por 60 s
while (tempo(k-1)<560)     
   [nivel3,yr]=LerURL('http://192.168.1.3/'); 
   x=nivel3;
   nivel1=p(1)*x+p(2)+0.4;
   
 if(tempo(k-1)>0 && tempo(k-1)<100)
     yr=4;
 end
if(tempo(k-1)>100 && tempo(k-1)<200)
     yr=15;
 end
 if(tempo(k-1)>200 && tempo(k-1)<320)
     yr=10;
 end
 if(tempo(k-1)>320 && tempo(k-1)<420)
     yr=20;
 end
 if(tempo(k-1)>420 && tempo(k-1)<560)
     yr=8;
 end
   %Cálculo do erro
   e = yr-nivel1;
   erroq = e^2;
   seq = seq+erroq;
   s = santerior + e;
   de = e-eanterior;
   
   %PID
   
   u =kp*e+ki*s+ kd*de;

     
   %Limites de Tensão da Bomba
   
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

 %Recebimento de Valores para o Próximo Loop
 
 santerior = s;
 eanterior = e;
 clc;

 %Mostra as Variáveis
 
 disp(['Nivel do tanque: ' ,num2str(nivel1)])
 disp(['Nivel de referência: ' ,num2str(yr)])
 disp(['Tensão na Bomba: ' ,num2str(pwm/51*3)]) % CONVERTE O VALOR DE 0 A 255 PARA 0 A 5!
 
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


%Índices de Desempenho
emq = seq/k;
Vmedio = su/k;

indice = a*emq + b*Vmedio;
disp(['Índice de Desempenho: ' ,num2str(indice)])

save('Tyfile.mat','T','y','-asciii')
type('Tyfile.txt')

