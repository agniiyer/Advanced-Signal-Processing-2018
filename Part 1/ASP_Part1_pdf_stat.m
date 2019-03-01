close all
clear all
clc

% Only rp3 is both stationary and ergodic.
v = rp3(1,100);
x = rp3(1,1000);
y = rp3(1,10000);

[v_freq,v_bin] = hist(v,100);
v_freq = v_freq/trapz(v_bin,v_freq);
subplot(4,1,1);
bar(v_bin,v_freq);
axis tight;
ylabel('Probability');
xlabel('x');
title('N = 100');
grid on
grid minor

[x_freq,x_bin] = hist(x,100);
x_freq = x_freq/trapz(x_bin,x_freq);
subplot(4,1,2);
bar(x_bin,x_freq);
axis tight;
ylabel('Probability');
xlabel('x');
title('N = 1000');
grid on
grid minor

[y_freq,y_bin] = hist(y,100);
y_freq = y_freq/trapz(y_bin,y_freq);
subplot(4,1,3);
bar(y_bin,y_freq);
axis tight;
ylabel('Probability');
xlabel('x');
title('N = 10000');
grid on
grid minor

z = ones(1,100).*0.5;
subplot(4,1,4);
plot(z);
axis tight;
ylabel('Probability');
xlabel('x');
title('Theoretical PDF');
grid on
grid minor
