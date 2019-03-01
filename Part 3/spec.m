clear all
close all
clc

load num

std_n = 25; % Adding noise for subsection 4. Change to 0,2,7
n = randn(1, Fs * t) * std_n;
y = y + n;


figure(1); % time domain signal
x = linspace(0, 5.25, 172032); % signal is 5.25 seconds long with a sampling rate of 32768Hz
plot(x, y);
title(['Time Domain Signal for Landline Number ' num2str(number)]);
xlabel('Time (seconds)')
ylabel('Signal Amplitude')
% axis([0 0.75 -2 2]); % only first 2 numbers and 1st blank
grid on
grid minor


% Hanning window used. Each segment is 8192 samples long, so FFT is 
% evaluated at 8192 frequencies for each window.

figure(2); % spectrogram
spectrogram(y, hann(8192), 0, 8192, 32768, 'yaxis');
ylim([0.250 1.750])
title('Spectrogram of Dial Tone Signal');
xlabel('Time (seconds)');

save myenv;
