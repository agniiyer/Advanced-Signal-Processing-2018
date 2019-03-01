clear all
close all
clc

N = 512;
x = randn(1, N);
Px = pgm(x);

% f = linspace(0, 0.5, N/2+1); % Normalized frequencies to 0.5 showing only one symmetric part
% stem(f, Px(1:N/2+1));

norm_freq = @(N) 0:1/N:(N-1)/N; % Normalized frequencies to 1 showing both symmetric parts
nf = norm_freq(length(x));
stem(nf, Px);

title(['PSD estimate of WGN for N = ' num2str(N)]);
xlabel('Normalized Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor