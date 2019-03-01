close all
clear all
clc

sd = 0.1;
adap_gain = 0.1;

a = 1;
b = [1 2 3 2 1];

N = 1000;
N_w = length(b);

x = randn(N,1);
y = filter(b, a, x);
y = y./sqrt(sum(b.*b));

n = sd*randn(N,1);
z = y+n;

SNR = 10*log10(var(y)/var(n));

[y_e,e,w] = lms_gs(x, z, adap_gain, N_w+1);
w_sc = w.*sqrt(sum(b.*b));
error_squared = e.^2;

figure(1)
hold on
plot(w_sc(1,:), 'DisplayName', 'w[1]')
plot(w_sc(2,:), 'DisplayName', 'w[2]')
plot(w_sc(3,:), 'DisplayName', 'w[3]')
plot(w_sc(4,:), 'DisplayName', 'w[4]')
plot(w_sc(5,:), 'DisplayName', 'w[5]')
title('Time evolution of coefficients')
xlabel('Sample')
ylabel('Coefficients')
legend('show')
grid on
grid minor


figure(2)
plot(error_squared)
title('LMS Error squared')
xlabel('Sample')
ylabel('Error')
legend('show')
grid on
grid minor

