%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% _%TANQUE SIMPLES
% clc
% clear
% 
% %Dados de Entrada
% 
% Km=3.3; %Fluxo da Bomba (cm3/V.s)
% g=981; %cm2/s;
% rol= 1; %g/cm3
% rtank = 4.45/2; %Diâmetro do tanque (cm)
% 
% Ltubo = 5; %cm
% rtubo = 0.48/2; %medium outflow (cm)
% nfluido = 0.01003; %g/cm.s
% R =(8*nfluido*Ltubo)/(pi*(rtubo^4));
% A=pi*(rtank^2);
% 
% %Equação de Transf (s)
% s=tf('s');
% G2=((Km)/(((R*A^2/((rol*g)))*s^2)+(2*A*s)+((rol*g)/R)));
% step(G2)
% 
% %Equação em Z+ZOH
% Ts=1/50;
% G_z=c2d(G2, Ts, 'zoh');
% disp(G_z)_
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ANALISE TEMPO DISCRETO

clc
clear

L1(1)=0;
L2(1)=0;
u(1)=0;
s(1)=0;
e(1)=0;
ref=15;

kp=0.846;
ki=0.28;
kd=0.07;
Tsimu=3000;
N=Tsimu;
seantes=0;
ukantes=0;

for k=2:Tsimu;
    L1(k)=0.9678*L1(k-1)+0.037573*u(k-1);
    L2(k)=0.006522*L1(k-1)+0.9678*L2(k-1)+0.037573*u(k-1);
    e(k)=ref-L2(k);
    s(k)=s(k-1)+e(k);
    de(k)=e(k)-e(k-1);
    u(k)=kp*e(k)+ki*s(k)+kd*de(k);
     if u(k)>15
        u(k)=15;
    end
    if u(k)<0
        u(k)=0;
    end
    MSE=(1/N)*(e(k)^2+seantes);
    iu=(1/N)*(u(k)+ukantes);
        I=(0.5*(MSE))+(0.5*iu);
    seantes=e(k)^2;
    ukantes=u(k);

end
  
plot(L1,'r');
hold on
plot(L2,'k');
plot(1:Tsimu,ref,'.r');
plot(1:Tsimu,ref*1.02,'.g');
plot(1:Tsimu,ref*0.98,'.g');
xlabel('Tempo (s)')
ylabel('Nivel (cm)')
title('Sistema em Malha Fechada com PID')
f1=figure;
plot(u)
xlabel('Tempo (s)')
ylabel('Tensão(cm)')
title('Sistema em Malha Fechada com PID')
f2=figure;