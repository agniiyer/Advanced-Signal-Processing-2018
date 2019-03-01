clear all
close all
clc

m = zeros(1,10);
s = zeros(1,10);
bias_mean = zeros(1,10);
bias_std = zeros(1,10);

for n=1:10
   a=randn(1000,1);
   m(n)=mean(a);
   s(n)=std(a);
   bias_mean(n) = 0 - m(n); % Theoretical mean is 0
   bias_std(n) = 1 - s(n); % Theoretical standard deviation is 1
end

subplot(2,1,1);
stem(bias_mean);
xlabel('Realisation of X');
ylabel('Bias in Mean');
hold on;
line([1 10],[0 0]);
grid on
grid minor

subplot(2,1,2);
stem(bias_std);
xlabel('Realisation of X');
ylabel('Bias in Standard Deviation');
hold on;
line([1 10],[1 1]);
grid on
grid minor

