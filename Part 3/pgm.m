function P = pgm(x)
    N = length(x);
    xdft = fft(x);
    P = (1/N).*(abs(xdft).^2);
end