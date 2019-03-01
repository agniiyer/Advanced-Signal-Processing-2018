function pdf(v)
[freq,bin] = hist(v,100); % Returns frequency and centre of each bin.

% Need to scale PDF so that the total integral is 1. Dividing by N is only accurate when bins
% are small. Dividing by the trapezium underneath the curve gives a better
% approximation.
freq = freq/trapz(bin,freq);
bar(bin,freq);
xlabel('x');
ylabel('Probability');
grid on
grid minor