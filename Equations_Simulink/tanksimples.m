%TANQUE SIMPLES
clc
clear

%Dados de Entrada

Km=3.3; %Fluxo da Bomba (cm3/V.s)
g=981; %cm2/s;
rol= 1; %g/cm3
rtank = 4.45/2; %Diâmetro do tanque (cm)

Ltubo = 5; %cm
rtubo = 0.48/2; %medium outflow (cm)
nfluido = 0.01003; %g/cm.s
R =(8*nfluido*Ltubo)/(pi*(rtubo^4));

%Equação de Transf (s)
s=tf('s');
G=3*Km/((s*(pi*(rtank^2)))+(rol*g/R));
step(G)

%Equação em Z+ZOH
Ts=1/50;
G_z=c2d(G, Ts, 'zoh');
G_zr=3*G_z;
zpk(G_zr)

%Malha Aberta

numGz= 0.02955;
denGz= [1 -0.9678];
tank_g=tf(numGz, denGz, Ts);
[x,t]= step(tank_g, 10);
stairs(t,x)

%Malha Fechada

G_zf = feedback(G_z,1);
[y,t] = step(G_zf,12);
stairs(t,y);
xlabel('Time (s)')
ylabel('Nivel (cm)')
title('Stairstep Response: Original')
f1=figure;



