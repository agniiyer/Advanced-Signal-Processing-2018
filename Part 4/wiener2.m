clear all
close all
clc

sd = [0.01 0.1 0.5 1.4 2.5 3.1]; % Since variance spans [0.1..10]

N_w = 5;

std_y = zeros(1,length(sd));

w_optimal = zeros(length(sd),N_w);

SNR = zeros(1,length(sd));

for i = 1:length(sd)
    [w_optimal(i,:),SNR(i),std_y(i)] = wiener_coeffs(sd(i), N_w);
end

for i = 1:length(sd)
    fprintf('SD = %f',sd(i));
    disp(w_optimal(i,:));
    disp(SNR(i));
end

plot(sd,SNR)
xlabel('Standard Deviation')
ylabel('SNR(dB)')
title('SNR vs Standard Deviation of Noise')
grid on
grid minor