load sunspot.dat
N=250;

sun = sunspot(:,2); % Given that sunspot data is in the second column.
[a,b] = xcorr(sun(1:N),'unbiased'); % Only take first N values from sunspot.zsun_acf = sun_acf/sun_acf(N);

sun_norm = zscore(sun(1:N)); % Standardizes values to 0 mean and unit variance.
[c,d] = xcorr(sun_norm(1:N),'unbiased');

%{
subplot(1,2,1);
stem(b,a);
grid on;
grid minor;
xlabel('Year Lag');
ylabel('ACF');
title(['ACF of Sunspot Data for N=' num2str(N)]); % Vector of string variables

subplot(1,2,2);
%}
stem(d,c);
axis([-50 50 -1.5 1.5]);
grid on;
grid minor;
xlabel('Year Lag');
ylabel('ACF');
title(['ACF of Normalised Sunspot Data for N=' num2str(N)]);
