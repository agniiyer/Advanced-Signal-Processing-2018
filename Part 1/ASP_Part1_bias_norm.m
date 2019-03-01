clear all
close all
clc

m = zeros(1,10);
s = zeros(1,10);
bias_mean = zeros(1,10);
bias_std = zeros(1,10);

for n=1:10
   a=rand(1,1000);
   m(n)=mean(a);
   s(n)=std(a);
   bias_mean(n) = 0.5 - m(n); % Theoretical mean is 0.5
   bias_std(n) = 0.2887 - s(n); % Theoretical standard deviation is 0.2887
end

subplot(2,1,1);
stem(bias_mean);
xlabel('Realizations of X');
ylabel('Mean Error');
grid on
grid minor

subplot(2,1,2);
stem(bias_std);
xlabel('Realizations of X');
ylabel('Standard Deviation Error');
grid on
grid minor
