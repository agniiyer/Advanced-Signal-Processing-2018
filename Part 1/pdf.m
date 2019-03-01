close all
clear all
clc

N = 10000; % Needs to be at least 100. More samples, more accuracy, i.e, better matching of theoretical and estimated.
v = randn(1,N);
[freq,bin] = hist(v,100); % Returns frequency and centre of each bin.

% Need to scale PDF so that the total integral is 1. Dividing by N is only accurate when bins
% are small. Dividing by the trapezium underneath the curve gives a better
% approximation.
freq = freq/trapz(bin,freq);
bar(bin,freq);
xlabel('x')
ylabel('Probability')
title('Estimated PDF of N(0,1)')
grid on
grid minor