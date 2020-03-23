%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TANQUE SIMPLES FUNÇÃO DE TRANSF.
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
% 
% %Equação de Transf (s)
% s=tf('s');
% G=3*Km/((s*(pi*(rtank^2)))+(rol*g/R));
% step(G)
% 
% %Equação em Z+ZOH
% Ts=1/50;
% G_z=c2d(G, Ts, 'zoh');
% G_zr=3*G_z;
% zpk(G_zr)
% 
% %Malha Aberta
% 
% numGz= 0.02955;
% denGz= [1 -0.9678];
% tank_g=tf(numGz, denGz, Ts);
% [x,t]= step(tank_g, 10);
% stairs(t,x)
% 
% %Malha Fechada
% 
% G_zf = feedback(G_z,1);
% [y,t] = step(G_zf,12);
% stairs(t,y);
% xlabel('Time (s)')
% ylabel('Nivel (cm)')
% title('Stairstep Response: Original')
% f1=figure;_
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ANALISE TEMPO DISCRETO

clc
clear


L2(1)=0;
u(1)=0;
s(1)=0;
e(1)=0;
ref=15;

kp=1.928;
ki=0.030557;
kd=0.8777;
Tsimu=3000;
N=Tsimu;
seantes=0;
ukantes=0;
% tic;
for k=2:Tsimu;
    L2(k)=0.9678*L2(k-1)+0.037573*u(k-1);
    e(k)=ref-L2(k);
    s(k)=s(k-1)+e(k);
    de(k)=e(k)-e(k-1);
    u(k)=kp*e(k)+ki*s(k)+kd*de(k);
    %u=Kp*e+Ki*s+Kd*de; %PID discreto
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
%     toc;
end
disp('O Valor do Erro Quadrático (MSE) é:')
disp(MSE)
disp('A média do sinal de controle é (iu):')
disp(iu)
disp('O Índice de desenpenho é:')
disp(I)

plot(L2);
hold on
plot(1:Tsimu,ref,'.r');
plot(1:Tsimu,ref*1.02,'.g');
plot(1:Tsimu,ref*0.98,'.g');
xlabel('Tempo (s)')
ylabel('Nivel (cm)')
title('Sistema em Malha Fechada com PID')
f1=figure;
plot(u)
xlabel('Tempo (s)')
ylabel('Tensão (V)')
title('Sistema em Malha Fechada com PID')