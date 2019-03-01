clear all
clc
load Part2_5.mat

alpha1 = 1;
alpha2 = 0.6;
hd = RRI_trial2;
heart_rate = 60./hd;

h_avg = reshape(heart_rate,[10 100]);

h_avg_alpha1 = zeros(1,size(h_avg,2));
for i = 1:size(h_avg_alpha1,2)
    h_avg_alpha1(i) = (1/10)*alpha1*sum(h_avg(:,i));
end

h_avg_alpha2 = zeros(1,size(h_avg,2));
for i = 1:size(h_avg_alpha2,2)
    h_avg_alpha2(i) = (1/10)*alpha2*sum(h_avg(:,i));
end

subplot(3,1,1)
pdf(heart_rate)
axis([0 200 0 .1]);
% axis tight
xlabel('Sample Value (BPM)')
title('PDE of original heart rate')

subplot(3,1,2)
pdf(h_avg_alpha1)
axis([0 200 0 .25]);
% axis tight
title(['PDE of averaged heart rate for \alpha = ' num2str(alpha1)]);
xlabel('Sample Value (BPM)')

subplot(3,1,3)
pdf(h_avg_alpha2)
axis([0 200 0 .4]);
% axis tight
title(['PDE of averaged heart rate for \alpha = ' num2str(alpha2)])
xlabel('Sample Value (BPM)')