clc;
clear;

x = randn(1000,1);
order=4;
y = filter(ones(order,1),[1],x);
acf_est = xcorr(y,'unbiased');

stem([-999:1:999],acf_est); % Plotting the ACF of the filter output.
axis([-20 20 -2 10]);
grid on;
grid minor;
xlabel('Tau (Time Lag)');
ylabel('Signal Amplitude');
title(['ACF of ' num2str(order) 'th Order MA Filter for 1000 WGN samples']);

