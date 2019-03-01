clear all
close all
clc

n = 51:50:1001;
var = 51:50:1001;
load NASDAQ.mat
prices = NASDAQ.Close;
r_xx = xcorr(zscore(prices),'unbiased');

[N,VAR] = meshgrid(n,var);
crlb_var = 2*(VAR.^2)./N;
crlb_a = (VAR)./(N*r_xx(924));

figure(1)
h = heatmap(n, var, crlb_var);
h.Colormap = parula;
h.ColorScaling = 'log';
title('Heatmap of Noise Variance')
xlabel('N')
ylabel('Variance')

figure(2)
h = heatmap(n, var, crlb_a);
h.Colormap = parula;
h.ColorScaling = 'log';
title('Heatmap of a1');
xlabel('N')
ylabel('Variance')
