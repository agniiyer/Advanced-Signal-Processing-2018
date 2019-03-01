
clear all
close all
clc

sd = 1;
a = [1 0.9 0.2];
b = 1;
N = 10000;
N_w = length(a);
n = sd*randn(N,1);

x = filter(b, a, n);
x = x./sqrt(sum(a.*a));
xDelayed = [0; x(1:N-1)];


figure(1)
a_gain = 0.01;
[~, ~, w] = n_lms(xDelayed, x, a_gain, 3);
wScaled = w.*sqrt(sum(b.*b));
hold on
plot(wScaled(1,:))
plot(wScaled(2,:))
title('Evolution of coefficients using standard LMS');
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')

figure(2)
a_gain = 0.01;
[~,~,w] = signed_error(xDelayed, x, a_gain, 3);
wScaled = w.*sqrt(sum(b.*b));
hold on
plot(wScaled(1,:))
plot(wScaled(2,:))
title('Evolution of coefficients using Signed Error');
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')

figure(3)
a_gain = 0.01;
[~,~,w] = sign_regressorlms(xDelayed, x, a_gain, 3);
wScaled = w.*sqrt(sum(b.*b));
hold on
plot(wScaled(1,:))
plot(wScaled(2,:))
title('Evolution of coefficients using Signed Regressor');
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')

figure(4)
a_gain = 0.01;
[x_predict,e,w] = sign_of_sign(xDelayed, x, a_gain, 3);
wScaled = w.*sqrt(sum(b.*b));
hold on
plot(wScaled(1,:))
plot(wScaled(2,:))
title('Evolution of coefficients using Sign-Sign');
xlabel('Sample')
ylabel('Coefficient')
grid on
grid minor
legend('a1','a2')

