close all
clear all
clc

N = 1064;
x = randn(1, N);

% Given filter coefficients
a = [1 0.9];
b = 1;

y = filter(b, a, x);
y = y(41:end); % Remove first 40 samples

figure(1)
subplot(2,1,1)
plot(x);
title('Signal X')
xlabel('Sample N')
ylabel('Signal Amplitude')
grid on
grid minor

subplot(2,1,2)
plot(y);
title('Signal Y')
xlabel('Sample N')
ylabel('Signal Amplitude')
grid on
grid minor


[h, w] = freqz(b, a, 512); % Given function to obtain ideal PSD of filtered signal

Px = pgm(y);

figure(2)
hold on
plot(w/(2*pi), abs(h).^2, 'DisplayName', 'Exact PSD', 'LineWidth', 2);
plot(w/(2*pi), Px(1:(N-40)/2), 'DisplayName', 'Periodogram Estimated PSD');

% axis([0.4 0.5 0 400]); % For zooming in

title('PSD using AR(1) Process');
xlabel('Normalized Frequency (x 2\pi radians/sample)')
ylabel('Amplitude')
legend('show')
grid on
grid minor