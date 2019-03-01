clear all
close all
clc

N = 32;
segs = 32; % Blocks for averaging to give 8 segments
x = randn(segs, N);

Px = pgm(x'); % fft in pgm works on columns of the input matrix
Px_avg = mean(Px'); % Mean of 8 segments

% norm_freq = @(N) 0:1/N:(N-1)/N;
% nf = norm_freq(length(x));
% stem(nf, Px_avg);

f = linspace(0, 0.5, N/2+1);
stem(f, Px_avg(1:N/2+1));

title(['Averaged periodogram for ' num2str(N*segs) ' WGN samples: ' num2str(segs) ' segments']);
xlabel('Normalized Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor