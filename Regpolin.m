clc
clear all
x=0:300;

[p,s]=polyfit([47, 84,129,172,215,254],[0.6, 5,10,15,20,25],5);

figure
plot(x,p(1)*x.^5+p(2)*x.^4+p(3)*x.^3+p(4)*x.^2+x*p(5)+p(6))
xlabel('Valor em Bits');
ylabel('Valor do Nível (cm)');
title('Curva bit x nível para ajuste de sensor do Tanque 3 (Trapezoidal)');

