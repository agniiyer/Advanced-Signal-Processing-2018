close all
clear all
clc

sd = 1; % For noise

a = [1 0.9 0.2];
b = 1;

N = 5000;
N_w = length(a);

n = sd*randn(N,1);

x = filter(b, a, n);
x = x./sqrt(sum(a.*a));
xDelayed = [0; x(1:N-1)];

adap_gain = [0.001 0.01 0.05 0.1]; % Input gain values

w_sc1 = lms_diffgain(adap_gain(1),xDelayed,x,b);
w_sc2 = lms_diffgain(adap_gain(2),xDelayed,x,b);
w_sc3 = lms_diffgain(adap_gain(3),xDelayed,x,b);
w_sc4 = lms_diffgain(adap_gain(4),xDelayed,x,b);

figure(1)
hold on
plot(w_sc1(1,:))
plot(w_sc1(2,:))
title(['Time evolution of the coefficients for \mu = ',num2str(adap_gain(1))])
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')


figure(2)
hold on
plot(w_sc2(1,:))
plot(w_sc2(2,:))
title(['Time evolution of the coefficients for \mu = ',num2str(adap_gain(2))])
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')


figure(3)
hold on
plot(w_sc3(1,:))
plot(w_sc3(2,:))
title(['Time evolution of the coefficients for \mu = ',num2str(adap_gain(3))])
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')


figure(4)
hold on
plot(w_sc4(1,:))
plot(w_sc4(2,:))
title(['Time evolution of the coefficients for \mu = ',num2str(adap_gain(4))])
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')