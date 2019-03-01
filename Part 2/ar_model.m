close all;
clear;
clc;

load sunspot.dat
sun=sunspot(:, 2);
sun = zscore(sun);
N = 100;

futures_1_1 = zeros(N,1);
a = ar(sun(1:N), 1, 'yw'); % Polynomial model with identifiable parameters
futures_1_1 = predict(a, sun(1:N), 1);

futures_1_2 = zeros(N,1);
b = ar(sun(1:N), 1, 'yw');
futures_1_2 = predict(b, sun(1:N), 2);

futures_1_5 = zeros(N,1);
c = ar(sun(1:N), 1, 'yw');
futures_1_5 = predict(c, sun(1:N), 5);

futures_1_10 = zeros(N,1);
d = ar(sun(1:N), 1, 'yw');
futures_1_10 = predict(d, sun(1:N), 10);

futures_2_1 = zeros(N,1);
e = ar(sun(1:N), 2, 'yw');
futures_2_1 = predict(e, sun(1:N), 1);

futures_2_2 = zeros(N,1);
f = ar(sun(1:N), 2, 'yw');
futures_2_2 = predict(f, sun(1:N), 2);

futures_2_5 = zeros(N,1);
g = ar(sun(1:N), 2, 'yw');
futures_2_5 = predict(g, sun(1:N), 5);

futures_2_10 = zeros(N,1);
h = ar(sun(1:N), 2, 'yw');
futures_2_10 = predict(h, sun(1:N), 10);

futures_10_1 = zeros(N,1);
i = ar(sun(1:N), 10, 'yw');
futures_10_1 = predict(i, sun(1:N), 1);

futures_10_2 = zeros(N,1);
j = ar(sun(1:N), 10, 'yw');
futures_10_2 = predict(j, sun(1:N), 2);

futures_10_5 = zeros(N,1);
k = ar(sun(1:N), 10, 'yw');
futures_10_5 = predict(k, sun(1:N), 5);

futures_10_10 = zeros(N,1);
l = ar(sun(1:N), 10, 'yw');
futures_10_10 = predict(l, sun(1:N), 10);

x = linspace(1, N, N);
colors = distinguishable_colors(100); % For distinct colours

hold on
plot(x, sun(1:N),'DisplayName','Real Data');

% plot(x, futures_1_1,'DisplayName','AR(1), M=1');
% plot(x, futures_2_1,'DisplayName','AR(2), M=1');
% plot(x, futures_10_1,'DisplayName','AR(10)');


% plot(x, futures_1_2,'DisplayName','AR(1), M=2');
% plot(x, futures_2_2,'DisplayName','AR(2), M=2');
% plot(x, futures_10_2,'DisplayName','AR(10), M=2');


% plot(x, futures_1_5,'DisplayName','AR(1), M=5');
% plot(x, futures_2_5,'DisplayName','AR(2), M=5');
% plot(x, futures_10_5,'DisplayName','AR(10), M=5');


% plot(x, futures_1_10,'DisplayName','AR(1), M=10');
% plot(x, futures_2_10,'DisplayName','AR(2), M=10');
plot(x, futures_10_10,'DisplayName','AR(10), M=10');

title('Real and predicted sunspot data');
xlabel('Sample number N');
ylabel('Magnitude');
grid on
grid minor
legend('show')