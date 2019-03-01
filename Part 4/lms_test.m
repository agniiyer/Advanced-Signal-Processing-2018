clc
clear all
close all

N = 1000;
x = randn([N 1]);
adap_gain = 0.01;
sd = 0.1;

b = [1,2,3,2,1];
N_w = length(b);
y = filter(b,[1],x);
% y = zscore(y);

n = sd*randn([N 1]);
z = n+y;

sig_pow = sum(y.^2)/N;
noise_pow = sum(n.^2)/N;

SNR = 10*log10(sig_pow/noise_pow);

[y_est, e, w] = lms(x, z, adap_gain, N_w+1);

w_sc = w.*sqrt(sum(b.*b));
error_squared = e.^2;


figure(1)
hold on
plot(y_est, 'DisplayName', 'LMS Estimate', 'LineWidth', 0.8)
plot(y, 'DisplayName', 'Real signal')
xlabel('Time')
ylabel('Amplitude')
title('Accuracy of the LMS estimate (\mu = 0.01)')
grid on
grid minor
legend('show')


figure(2)
hold on
plot(w_sc(1,:), 'DisplayName', 'w[1]')
plot(w_sc(2,:), 'DisplayName', 'w[2]')
plot(w_sc(3,:), 'DisplayName', 'w[3]')
plot(w_sc(4,:), 'DisplayName', 'w[4]')
plot(w_sc(5,:), 'DisplayName', 'w[5]')
hold off
title('Time evolution of coefficients for \mu = 0.01');
xlabel('Sample');
ylabel('Coefficients');
grid on
grid minor
legend('show')


figure(3)
plot(error_squared);
title('Error squared (LMS)');
xlabel('Sample');
ylabel('Error');
grid on
grid minor


figure(4)
adap_gain = 0.002;
[~,~,w] = lms(x, z, adap_gain, N_w+1);
w_sc = w.*sqrt(sum(b.*b));
hold on
plot(w_sc(1,:), 'DisplayName', 'w[1]')
plot(w_sc(2,:), 'DisplayName', 'w[2]')
plot(w_sc(3,:), 'DisplayName', 'w[3]')
plot(w_sc(4,:), 'DisplayName', 'w[4]')
plot(w_sc(5,:), 'DisplayName', 'w[5]')
title('Time evolution of coefficients for \mu = 0.002');
xlabel('Sample')
ylabel('Coefficients')
grid on
grid minor
legend('show')


figure(5)
adap_gain = 0.13;
[~,~,w] = lms(x, z, adap_gain, N_w+1);
w_sc = w.*sqrt(sum(b.*b));
hold on
plot(w_sc(1,:), 'DisplayName', 'w[1]')
plot(w_sc(2,:), 'DisplayName', 'w[2]')
plot(w_sc(3,:), 'DisplayName', 'w[3]')
plot(w_sc(4,:), 'DisplayName', 'w[4]')
plot(w_sc(5,:), 'DisplayName', 'w[5]')
title('Time evolution of coefficients for \mu = 0.13');
xlabel('Sample')
ylabel('Coefficients')
grid on
grid minor
legend('show')


figure(6)
adap_gain = 0.27;
[~,~,w] = lms(x, z, adap_gain, N_w+1);
w_sc = w.*sqrt(sum(b.*b));
hold on
plot(w_sc(1,:), 'DisplayName', 'w[1]')
plot(w_sc(2,:), 'DisplayName', 'w[2]')
plot(w_sc(3,:), 'DisplayName', 'w[3]')
plot(w_sc(4,:), 'DisplayName', 'w[4]')
plot(w_sc(5,:), 'DisplayName', 'w[5]')
title('Time evolution of coefficients for \mu = 0.27');
xlabel('Sample')
ylabel('Coefficients')
grid on
grid minor
legend('show')


figure(7)
adap_gain = 0.4;
[y_e,e,w] = lms(x, z, adap_gain, N_w+1);
w_sc = w.*sqrt(sum(b.*b));
hold on
plot(w_sc(1,:), 'DisplayName', 'w[1]')
plot(w_sc(2,:), 'DisplayName', 'w[2]')
plot(w_sc(3,:), 'DisplayName', 'w[3]')
plot(w_sc(4,:), 'DisplayName', 'w[4]')
plot(w_sc(5,:), 'DisplayName', 'w[5]')
title('Time evolution of coefficients for \mu = 0.4')
xlabel('Sample')
ylabel('Coefficients')
grid on
grid minor
legend('show')
