clear all
close all
clc

N = 1000;
order = 10; % Filter order
gain = 0.01;

Fs = 44100;
% Fs = 16000; % Uncomment for sampling at 16 kHz

Rp = @(x,e) 10*log10(var(x)/var(e)); % Prediction Gain (given formula)

% Reading voice data and resampling for all letters:
file = 'E.m4a';
[e_temp,f] = audioread(file);
% audiowrite('e.wav', e_temp, Fs);
% e = audioread('e.wav');
e = resample(e_temp,Fs,f);

file = 'A.m4a';
[a_temp,f] = audioread(file);
% audiowrite('a.wav', a_temp, Fs);
% a = audioread('a.wav');
a = resample(a_temp,Fs,f);

file = 'S.m4a';
[s_temp,f] = audioread(file);
% audiowrite('s.wav', s_temp, Fs);
% s = audioread('s.wav');
s = resample(s_temp,Fs,f);

file = 'T.m4a';
[t_temp,f] = audioread(file);
% audiowrite('t.wav', t_temp, Fs);
% t = audioread('t.wav');
t = resample(t_temp,Fs,f);

file = 'X.m4a';
[x_temp,f] = audioread(file);
% audiowrite('x.wav', x_temp, Fs);
% x = audioread('x.wav');
x = resample(x_temp,Fs,f);


e_voice = e(1:N);
e_shift = [0; e_voice(1:N-1)];

a_voice = a(1:N);
a_shift = [0; a_voice(1:N-1)];

s_voice = s(1:N);
s_shift = [0; s_voice(1:N-1)];

t_voice = t(1:N);
t_shift = [0; t_voice(1:N-1)];

x_voice = x(1:N);
x_shift = [0; x_voice(1:N-1)];


% Applying LMS:
[e_predict,ee,e_w] = lms(e_shift, e_voice, gain, order); 
[a_predict,ae,a_w] = lms(a_shift, a_voice, gain, order); 
[s_predict,se,s_w] = lms(s_shift, s_voice, gain, order); 
[t_predict,te,t_w] = lms(t_shift, t_voice, gain, order); 
[x_predict,xe,x_w] = lms(x_shift, x_voice, gain, order); 

% % Applying gearshifting:
% [e_predict,ee,e_w] = lms_gs(e_shift, e_voice, gain, order); 
% [a_predict,ae,a_w] = lms_gs(a_shift, a_voice, gain, order);
% [s_predict,se,s_w] = lms_gs(s_shift, s_voice, gain, order); 
% [t_predict,te,t_w] = lms_gs(t_shift, t_voice, gain, order); 
% [x_predict,xe,x_w] = lms_gs(x_shift, x_voice, gain, order); 


% Uncomment the code below line 77 to line 145 to generate coefficient plots.

% %e
% 
% figure(1)
% hold on
% for i = 1:length(e_w(:,1))
%     plot(e_w(i,:));
% end
% hold off
% title('Evolution of the coefficients for letter "e"');
% xlabel('Sample');
% ylabel('Coefficients');
% grid on
% grid minor

% %a
% 
% figure(2)
% hold on
% for i = 1:length(a_w(:,1))
%     plot(a_w(i,:));
% end
% hold off
% title('Evolution of the coefficients for letter "a"');
% xlabel('Sample');
% ylabel('Coefficients');
% grid on
% grid minor
% 
% %s
% 
% figure(3)
% hold on
% for i = 1:length(s_w(:,1))
%     plot(s_w(i,:));
% end
% hold off
% title('Evolution of the coefficients for letter "s"');
% xlabel('Sample');
% ylabel('Coefficients');
% grid on
% grid minor
% 
% %t
% figure(4);
% hold on
% for i = 1:length(t_w(:,1))
%     plot(t_w(i,:));
% end
% hold off
% title('Evolution of the coefficients for letter "t"');
% xlabel('Sample');
% ylabel('Coefficients');
% grid on
% grid minor
% 
% %x
% figure(5);
% hold on
% for i = 1:length(x_w(:,1))
%     plot(x_w(i,:));
% end
% hold off
% title('Evolution of the coefficients for letter "x"');
% xlabel('Sample');
% ylabel('Coefficients');
% grid on
% grid minor


[MDL_e,AIC_e] = mdl_aic(e_predict,100);
[MDL_a,AIC_a] = mdl_aic(a_predict,100);
[MDL_s,AIC_s] = mdl_aic(s_predict,100);
[MDL_t,AIC_t] = mdl_aic(t_predict,100);
[MDL_x,AIC_x] = mdl_aic(x_predict,100);

% The optimal model order is the minimum value in the matrix
[~,IMDL_e] = min(MDL_e);
[~,IMDL_a] = min(MDL_a);
[~,IMDL_s] = min(MDL_s);
[~,IMDL_t] = min(MDL_t);
[~,IMDL_x] = min(MDL_x);

[~,IAIC_e] = min(AIC_e);
[~,IAIC_a] = min(AIC_a);
[~,IAIC_s] = min(AIC_s);
[~,IAIC_t] = min(AIC_t);
[~,IAIC_x] = min(AIC_x);

fprintf('The optimal model order for the letters are: \n')
fprintf('e_MDL = %d\n',IMDL_e)
fprintf('e_AIC = %d\n',IAIC_e)
fprintf('a_MDL = %d\n',IMDL_a)
fprintf('a_AIC = %d\n',IAIC_a)
fprintf('s_MDL = %d\n',IMDL_s)
fprintf('s_AIC = %d\n',IAIC_s)
fprintf('t_MDL = %d\n',IMDL_t)
fprintf('t_AIC = %d\n',IAIC_t)
fprintf('x_MDL = %d\n',IMDL_x)
fprintf('x_AIC = %d\n',IAIC_x)

% Prediction gains:
fprintf('Rp for "e" = %f\n',Rp(e,ee))
fprintf('Rp for "a" = %f\n',Rp(a,ae))
fprintf('Rp for "s" = %f\n',Rp(s,se))
fprintf('Rp for "t" = %f\n',Rp(t,te))
fprintf('Rp for "x" = %f\n',Rp(x,xe))