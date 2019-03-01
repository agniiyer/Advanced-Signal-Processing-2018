clear all
close all
clc

% A column vector of 100 random numbers between 0 and 1:
x = rand(1000,1);
stem(x);
xlabel('Sample n');
ylabel('Probability');
grid on
grid minor

% Given that X is a Uniform Distribution.
pd = makedist('Uniform', 'Lower',0,'Upper',1);

theo_mean = mean(pd);
disp(['Theoretical mean is ' num2str(theo_mean)]);
samp_mean = mean(x);
disp(['Sample mean is ' num2str(samp_mean)]);
mean_err = (theo_mean - samp_mean);
disp(['Mean error is ' num2str(mean_err)]);

theo_std = std(pd);
disp(['Theoretical std is ' num2str(theo_std)]);
samp_std = std(x);
disp(['Sample std is ' num2str(samp_std)]);
std_err = (theo_std - samp_std);
disp(['Std error is ' num2str(std_err)]);