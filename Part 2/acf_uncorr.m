x = randn(1000,1);
r = xcorr(x,'unbiased');
plot([-999:1:999],r); % Sets axis from -999 to 999 instead of 0 to 2000.
axis tight;
grid on;
grid minor;
xlabel('Tau (Time Lag)');
ylabel('Signal Amplitude');
title('Unbiased ACF of 1000 WGN samples');