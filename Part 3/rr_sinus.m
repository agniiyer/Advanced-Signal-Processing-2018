
% Call function in command window for each trial. Use trial_num = 1,2,3.
function rr_sinus(RRI_trial, RRI_fs, trial_num)

RRI_trial = zscore(RRI_trial);

N50 = RRI_fs*50;
N150 = RRI_fs*150;

PSD = pgm(RRI_trial);

% For window length of 50 seconds
size_50 = floor(length(RRI_trial)/N50);
RRI_avg_50 = zeros(1, N50);
PSD50 = zeros(1, N50);

for i = 0:size_50-1
    RRI_avg_50 =  RRI_trial(i*N50 + 1:(i+1)*N50);
    PSD50 = PSD50 +pgm(RRI_avg_50);
end

PSD50 = PSD50 ./ size_50;
PSD_avg_50 = pgm(PSD50);


% For window length of 150 seconds
size_150 = floor(length(RRI_trial)/N150);
RRI_avg_150 = zeros(1, N150);
PSD150 = zeros(1, N150);

for i = 0:size_150-1
    RRI_avg_150 = RRI_trial(i*N150 + 1:(i+1)*N150);
    PSD150 = PSD150 + pgm(RRI_avg_150);
end

PSD150 = PSD150 ./ size_150;
PSD_avg_150 = pgm(PSD150);


figure(1)
plot((0:length(PSD)/2 - 1)/length(PSD),PSD(1:length(PSD)/2))
ylim([0 40]) % For all trials
title(['PSD of RRI Trial ' num2str(trial_num)])
xlabel('Frequency')
ylabel('PSD')
grid on
grid minor


figure(2)
plot((0:99)/200, PSD_avg_50(1:100))
title(['PSD of RRI Trial ' num2str(trial_num) ' (50 seconds average)'])
xlabel('Normalized Frequency')
ylabel('PSD')
grid on
grid minor


figure(3)
plot((0:299)/600, PSD_avg_150(1:300))
title(['PSD of RRI Trial ' num2str(trial_num) ' (150 seconds average)']);
xlabel('Normalized Frequency')
ylabel('PSD')
grid on
grid minor

end