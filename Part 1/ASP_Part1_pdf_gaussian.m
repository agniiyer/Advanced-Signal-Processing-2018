clear all
close all
clc

% PDF tends to perfect normal distribution as N (number of samples) is made larger.
x = randn(10000,1);
[y,group] = hist(x); % Returns bin limits and number of elements in each bin
bar(group,(y/10000)); % Uses same bins but normalizes number of elements
xlabel('x');
ylabel('Probability');
title('Estimated PDF of N(0,1)')
hold on
pd = makedist('Normal',0,1);
grid on
grid minor