load sunspot.dat
p=10; % Order 

sun = sunspot(:,2); % Given that sunspot data is in the second column.
sun_norm = zscore(sun); % Standardizes values to 0 mean and unit variance.

parc_len = 10;
parc = zeros(parc_len,1);
parc_norm = zeros(parc_len,1);

for i = 1:parc_len
    coefs = aryule(sun, i);
    parc(i) = -coefs(i+1);
end

for i = 1:parc_len
    coefs_norm = aryule(sun_norm, i);
    parc_norm(i) = -coefs_norm(i+1);
end

% generate x axis
x = linspace(1, parc_len, parc_len);
stem(x,parc,'DisplayName','Empirical PCF');
hold on;
stem(x,parc_norm,'DisplayName','Zero Mean PCF');
grid on;
grid minor;
xlabel('Tau');
ylabel('PCF');
title('Partial Correlation of sunspot time series');
legend('show');
