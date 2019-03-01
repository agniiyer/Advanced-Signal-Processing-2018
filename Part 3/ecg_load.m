clc
clear
close all

load RAW.mat

int1_finish = 2.5*10^5;
int2_finish = 5*10^5;
int3_finish = 7.5*10^5;

Trial_1 = data(1:int1_finish);
Trial_2 = data(int1_finish:int2_finish);
Trial_3 = data(int2_finish:int3_finish);

[RRI_trial1,RRI_fs1] = ECG_to_RRI(Trial_1,fs);
[RRI_trial2,RRI_fs2] = ECG_to_RRI(Trial_2,fs);
[RRI_trial3,RRI_fs3] = ECG_to_RRI(Trial_3,fs);

save('Part2_5.mat')