clear all
close all
clc

v = rp3(100,100); % Input (100,100) for Part 1.2.1 and (4,1000) for Part 1.2.2

disp(mean(mean(v))); % Theoretical mean is 0.5 for rp3. Can be found by increasing M and N.
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
