clear all
close all
clc

v = rp1(1,1000);
subplot(2,1,1);
plot(v);
axis tight;
xlabel('Time');
ylabel('Signal Amplitude');
grid on
grid minor

[v_freq,v_bin] = hist(v,100);
v_freq = v_freq/trapz(v_bin,v_freq);
subplot(2,1,2);
bar(v_bin,v_freq);
axis tight;
xlabel('x');
ylabel('Probability');
grid on
grid minor