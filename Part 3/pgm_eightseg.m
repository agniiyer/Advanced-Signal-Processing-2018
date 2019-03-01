clear all
close all
clc

wgn = randn(1,1024);
norm_freq = @(N) 0:1/N:(N-1)/N; % Normalizing frequency to max 1

PSD = pgm(wgn);
PSD = reshape(PSD,[128 8]); % 128 rows, 8 columns for 8 sets

nf = norm_freq(128);

subplot(2,4,1)
plot(nf,PSD(:,1))
title('First Segment')
xlabel('Normalized Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,2)
plot(nf,PSD(:,2))
title('Second Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,3)
plot(nf,PSD(:,3))
title('Third Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,4)
plot(nf,PSD(:,4))
title('Fourth Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,5)
plot(nf,PSD(:,5))
title('Fifth Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,6)
plot(nf,PSD(:,6))
title('Sixth Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,7)
plot(nf,PSD(:,7))
title('Seventh Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor

subplot(2,4,8)
plot(nf,PSD(:,8))
title('Eighth Segment')
xlabel('Normalised Frequency (x 2\pi radians per sample)')
ylabel('PSD')
grid on
grid minor