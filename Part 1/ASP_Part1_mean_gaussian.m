clear all
close all
clc

x = randn(1000,1);
plot(x,'.','DisplayName','Samples of Random Variable'); % Plots only data points with a dot
xlabel('Sample');
ylabel('Probability');
axis tight;

pd = makedist('Normal',0,1); % Normal distribution with mean = 0 and std = 1
hold on;
line([0 1000],[0 0],'DisplayName','Theoretical Mean', 'Color', 'r', 'LineWidth', 2);
legend('show');
grid on
grid minor

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