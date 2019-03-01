clear all
close all
clc

v = rp2(100,100); % Input (100,100) for Part 1.2.1 and (4,1000) for Part 1.2.2

% Run several iterations of rp2 to show how mean of mean and mean of std can
% vary. Create a table for the report.

disp(mean(mean(v)));
disp(mean(std(v)));

% Plotting mean and std of v:
subplot(2,1,1);
plot(mean(v));
xlabel('Time');
ylabel('Mean');
grid on
grid minor

subplot(2,1,2);
plot(std(v));
xlabel('Time');
ylabel('Standard Deviation');
grid on
grid minor