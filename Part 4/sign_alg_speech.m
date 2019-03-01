clear all
close all
clc

Fs = 44100;
% Fs = 16000;

file = 'A.m4a';
[a_temp,f] = audioread(file);
% audiowrite('a.wav', a_temp, Fs);
% a = audioread('a.wav');
a = resample(a_temp,Fs,f);

N=10000;
order = 8; % For filter
gain = 0.01;

a_voice = a(1:N);
a_shift = [0; a_voice(1:N-1)];

[a_predict_lms,~,a_w] = n_lms(a_shift, a_voice, gain, order);
[a_predict_signed_error,~,a_w_signederror] = signed_error(a_shift, a_voice, gain, order);
[a_predict_sign_regressorlms,~,a_w_signregressor] = sign_regressorlms(a_shift, a_voice, gain, order);
[a_predict_sign_of_sign,~,a_w_signofsign] = sign_of_sign(a_shift, a_voice, gain, order);


[MDL_a_lms,AIC_a_lms] = mdl_aic(a_predict_lms,100);
[MDL_a_signed_error,AIC_a_signed_error] = mdl_aic(a_predict_signed_error,100);
[MDL_a_sign_regressor,AIC_a_sign_regressor] = mdl_aic(a_predict_sign_regressorlms,100);
[MDL_a_sign_of_sign,AIC_a_sign_of_sign] = mdl_aic(a_predict_sign_of_sign,100);

% Finding the minimum order: 
[~,IMDL_a_lms] = min(MDL_a_lms);
[~,IAIC_a_lms] = min(AIC_a_lms);

[~,IMDL_a_signed_error] = min(MDL_a_signed_error);
[~,IAIC_a_signed_error] = min(AIC_a_signed_error);

[~,IMDL_a_sign_regressor] = min(MDL_a_sign_regressor);
[~,IAIC_a_sign_regressor] = min(AIC_a_sign_regressor);

[~,IMDL_a_sign_of_sign] = min(MDL_a_sign_of_sign);
[~,IAIC_a_sign_of_sign] = min(AIC_a_sign_of_sign);

fprintf('LMS\n')
fprintf('a_MDL = %d\n',IMDL_a_lms)
fprintf('a_AIC = %d\n',IAIC_a_lms)

fprintf('Signed Error\n')
fprintf('a_MDL = %d\n',IMDL_a_signed_error)
fprintf('a_AIC = %d\n',IAIC_a_signed_error)

fprintf('Signed Regressor\n')
fprintf('a_MDL = %d\n',IMDL_a_sign_regressor)
fprintf('a_AIC = %d\n',IAIC_a_sign_regressor)

fprintf('Sign of Sign\n')
fprintf('a_MDL = %d\n',IMDL_a_sign_of_sign)
fprintf('a_AIC = %d\n',IAIC_a_sign_of_sign)

figure(1)
hold on
for i = 1:length(a_w(:,1))
    plot(a_w(i,:));
end
title('Evolution of coefficients for "a" (Standard LMS)');
xlabel('Sample');
ylabel('Coefficients');
grid on
grid minor

figure(2)
hold on
for i = 1:length(a_w(:,1)) % Length = 20
    plot(a_w_signederror(i,:));
end
title('Evolution of coefficients for "a" (Signed error)');
xlabel('Sample');
ylabel('Coefficients');
grid on
grid minor

figure(3)
hold on
for i = 1:length(a_w(:,1))
    plot(a_w_signregressor(i,:));
end
title('Evolution of coefficients for "a" (Signed regressor)');
xlabel('Sample');
ylabel('Coefficients');
grid on
grid minor

figure(4)
hold on
for i = 1:length(a_w(:,1))
    plot(a_w_signofsign(i,:));
end
title('Evolution of coefficients for "a" (Sign Sign)');
xlabel('Sample');
ylabel('Coefficients');
grid on
grid minor