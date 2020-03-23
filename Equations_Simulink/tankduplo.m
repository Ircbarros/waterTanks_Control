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
A=pi*(rtank^2);

%Equação de Transf (s)
s=tf('s');
G2=((Km)/(((R*A^2/((rol*g)))*s^2)+(2*A*s)+((rol*g)/R)));
step(G2)

%Equação em Z+ZOH
Ts=1/50;
G_z=c2d(G2, Ts, 'zoh');
disp(G_z)



