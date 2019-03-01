clear all
close all
clc

load Part2_5.mat
h_data(:, 1) = RRI_trial3;

h_data(:, 1) = detrend(h_data(:, 1));

N = length(h_data(:, 1));

corr(:, 1) = xcorr(h_data(:, 1), 'unbiased');

% scale corr to have a value of 1 at tau = 0
corr(:, 1) = corr(:, 1)/corr(N, 1);

x = linspace(-N+1, N-1, 2*N-1);

plot(x, corr(:, 1));
% axis tight
axis([-1000 1000 -1 1]);

title('ACF of RRI Trial 3');
xlabel('Tau');
ylabel('Signal Amplitude');
grid on
grid minor