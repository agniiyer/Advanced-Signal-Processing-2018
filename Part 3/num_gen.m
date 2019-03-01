clear all
close all
clc

load freq

Fs = 32768; % Given sampling rate
t = 5.25; % Given time duration of total sequence

number = randi([0 9], 1, 8); % 1x8 matrix of random numbers between 0 and 9

number = [0 2 0 number]; % append 020 to phone number

% Since the sine wave is 0.25 seconds long, 8192 samples in 0.25 secs gives a sampling rate of 32768 Hz
x = linspace(0, 0.25, 8192);

y = []; % Output signal

% For 10 digits and 10 blanks
for i=1:10
    
    temp1 = sin(2 * pi * freqs(1, number(i)+1) * x) + sin(2 * pi * freqs(2, number(i)+1) * x); 
    temp2 = zeros(1, 8192);
    y = [y temp1 temp2];
    
end

% Generate 11th number separately since you don't need a blank after this.
temp1 = sin(2 * pi * freqs(1, number(11)+1) * x) + sin(2 * pi * freqs(2, number(11)+1) *x);
y = [y temp1];

save num