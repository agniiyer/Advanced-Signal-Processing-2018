clear all
close all
clc

load sunspot.dat

orders = [1 2 10];

sun(:, 1) = sunspot(:, 2);
sun(:, 2) = zscore(sun(:, 1));
N = length(sun(:, 1));

h_orders = zeros(N, length(orders));

legend_str = cell(1, 1+length(orders));
legend_str{1, 1} = char('Periodogram Estimate of PSD');

for i = 1:length(orders)
    [a, var] = aryule(sun(:, 1), orders(i)); % Use sun(:,2) for normalised data

    [h(:, i), w] = freqz(var^(1/2), a, length(sun(:, 1))/2); % Use sun(:,2) for normalised data
    
    legend_str{1, i+1} = char(sprintf('Model Based Estimate of PSD: Order %d', orders(i))); 
end

Ps = pgm(sun(:, 1)); % Use sun(:,2) for normalised data

f = linspace(0, 0.5, N/2+1);

hold on
plot(f, Ps(1:N/2+1));

for i = 1:length(orders)
    plot(w/(2*pi), abs(h(:, i)).^2);
end

% axis([0 0.2 0 45]); % For zooming in normalised data
axis([0 0.15 0 7*10^5]); % For zooming in original data

title('PSD Estimate of Sunspot Data');
xlabel('Normalized Frequencies (x 2\pi radians/sample)');
ylabel('Magnitude');
legend(legend_str);
grid on
grid minor