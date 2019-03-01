load myenv

% FFT of selected numbers
[s, f, t] = spectrogram(y, hann(8192), 0, 8192, 32768);
% s has 21 columns. The columns are the digits and gaps in sequence

hold on
% Show db values. Need to hardcode position for the digit you want once you
% have the landline number.
plot(f, mag2db(abs(s(:, 15)))); 
plot(f, mag2db(abs(s(:, 13))));

% Noise signal for idle time. Will always be present at 1st gap in column 2
% of 21.
plot(f, mag2db(abs(s(:, 2))));


title('Magnitude spectrum of Dial Tone Signals')
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)')
legend('Number 1',...
       'Number 8',...
       'Idle time');
grid on
grid minor
xlim([0 2000]); % For all noisy versions
% axis([0 2000 -150 100]); % For noiseless version