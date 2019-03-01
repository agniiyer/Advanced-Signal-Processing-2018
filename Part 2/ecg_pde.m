clear all
close all
clc

load Part2_5.mat
hd = RRI_trial2; % Need to store in variable data type!
heartrate = 60./hd;
pdf(heartrate)
title('Probability Density Estimate (PDE) of original heart rate'); 
ylabel('PDE'); 
xlabel('Sample value');
grid on
grid minor