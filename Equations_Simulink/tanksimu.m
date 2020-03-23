clc
clear

L1(1)=0;
L2(1)=0;
u(1)=0;
s(1)=0;
e(1)=0;
ref=15;

kp=0.79;
ki=0.01;
kd=0.02;
Tsimu=3000;
N=Tsimu;
seantes=0;
ukantes=0;
% tic;
for k=2:Tsimu;
    L1(k)=0.9935*L1(k-1)+0.02955*u(k-1);
    L2(k)=L1(k-1)+0.9935*L2(k-1)+0.00009637*u(k-1);
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
%     toc;
end
  
plot(L1,'r');
hold on
plot(L2,'k');
plot(1:Tsimu,ref,'.r');
plot(1:Tsimu,ref*1.02,'.g');
plot(1:Tsimu,ref*0.98,'.g');
figure;
plot(u)