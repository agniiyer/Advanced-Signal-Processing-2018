clear all
close all
clc

N = 128;
x = randn(1, N);
Px = pgm(x);

a = 1;
b = 0.2*[1 1 1 1 1];

norm_freq = @(N) 0:1/N:(N-1)/N;
nf = norm_freq(length(x));

Px = pgm(x);
Px_s = filter(b, a, Px); % Smoothing

f = linspace(0, 0.5, N/2+1);

hold on
plot(nf, Px, 'DisplayName', 'Original PSD estimate'); % Original PSD
plot(f, Px_s(1:N/2+1), 'DisplayName', 'Smoothed PSD estimate'); % Smoothed version
axis([0 0.5 0 6]);
title(['Smoothed PSD estimate of WGN for N = ' num2str(N)]);
xlabel('Normalized Frequency (x \pi radians per sample)')
ylabel('PSD')
grid on
grid minor
legend('show');