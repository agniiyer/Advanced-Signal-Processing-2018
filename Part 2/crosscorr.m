clear;
clc;
x = randn(1000,1);
y = filter(ones(9,1),[1],x);
[a,b] = xcorr(x,y,'unbiased');

stem(b,a);
axis([-20 20 -1 2]);
grid on;
grid minor;
xlabel('Tau (Time Lag)');
ylabel('Signal Amplitude');
title('Cross correlation of input and output for 9th order MA filter');