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

acf = xcorr(y, 1, 'unbiased');

a1 = - acf(3)/acf(2);
var = acf(2) + a1 * acf(3);

sd = sqrt(var);

[h, w] = freqz(var^(1/2), [1 a1], 512);

[h_ideal, w_ideal] = freqz(b, a, 512);

Px = pgm(y);

hold on
plot(w/(2*pi), abs(h).^2, 'LineWidth', 2, 'DisplayName', 'Exact PSD');
plot(w/(2*pi), Px(1:(N-40)/2), 'DisplayName', 'Periodogram Estimated PSD');
plot(w_ideal/(2*pi), abs(h_ideal).^2, 'LineWidth', 2, 'DisplayName', 'Model Based Estimated PSD');

axis([0.4 0.5 0 400]); % For zooming in

title('Model Based PSD Estimate');
xlabel('Normalized Frequency (x 2\pi radians/sample)')
ylabel('Amplitude')
legend('show');
grid on
grid minor