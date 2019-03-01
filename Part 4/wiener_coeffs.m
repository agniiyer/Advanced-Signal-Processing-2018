% Call function in the command window as [a,b,c] = wiener_coeffs(sd, N_w)
% sd is the standard deviation of the noise and N_w is the number of
% coefficents.

function [w_optimal, SNR, std_y] = wiener_coeffs(sd, N_w)

N = 1000;
x = randn(N,1);

y = filter([1,2,3,2,1],[1],x);
std_y = std(y);

% y = zscore(y); % Normalizing

n = sd*randn(N,1);
z = n+y;

sig_pow = sum(y.^2)/N;
noise_pow = sum(n.^2)/N;

SNR = 10*log10(sig_pow/noise_pow);

rxx_c = xcorr(x,'unbiased');

R_xx = zeros(N_w,N_w);

for i = 1:N_w
    R_xx(:,i) = rxx_c(N-i+1:N+N_w-i);
end

p_zx = xcorr(z,x,'unbiased');
p_zx = p_zx(N:N+N_w-1);

w_optimal = R_xx\p_zx;

end