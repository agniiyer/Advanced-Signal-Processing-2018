clear all
close all
clc

load NASDAQ.mat
prices = NASDAQ.Close;
prices_norm = zscore(prices);
time = NASDAQ.Date;

%------------MDL/AIC------------

p=20; % Order

N = length(prices_norm);

x = zeros(N,10);

for i = 1:p
    ar = aryule(prices_norm(1:N), i);
    x(:,i) = filter(-1*ar(1:end),1,prices_norm);
end

E=zeros(N,p);
o = ones(1,p);
E(1,:) = (x(1,:)-o*prices_norm(1)).^2;

for i=2:N % Can't start with index 1 because of E(i-1)
    E(i,:) = (x(i,:)-o*prices_norm(i)).^2 + E(i-1,:);
end

MDL = log(E(N,(1:p))) + (1:p)*log(N)/N;
AIC = log(E(N,(1:p))) + (1:p)*2/N;
AIC_c = zeros(1,p);

for i=1:size(p)
    
    AIC_c(i) = AIC(i) + (2*(i))*((i)+1)/(N-(i)-1);
end

figure(1)
hold on;
plot(AIC,'DisplayName','AIC');
plot(MDL,'DisplayName','MDL');
plot(AIC_c,'DisplayName','AIC_c')
plot(log(E(N,:)),'DisplayName','Cumulative Error Squared');
% axis([0 20 -0.5 8]); % Overview
axis([0 20 6.85 6.95]); % Zoom
grid on;
grid minor;
xlabel('Model Order');
ylabel('Magnitude');
title(['AIC, MDL and Cumulative Error Squared from order p=0 to p=' num2str(p)]);
legend('show');

%------------PCF-------------

p=10; % Order 

parc_len = 10;
parc = zeros(parc_len,1);
parc_norm = zeros(parc_len,1);

for i = 1:parc_len
    coefs = aryule(prices, i);
    parc(i) = -coefs(i+1);
end

for i = 1:parc_len
    coefs_norm = aryule(prices_norm, i);
    parc_norm(i) = -coefs_norm(i+1);
end

% generate x axis
x = linspace(1, parc_len, parc_len);

figure(2)
stem(x,parc,'DisplayName','Empirical PCF');
hold on;
stem(x,parc_norm,'DisplayName','Zero Mean PCF');
grid on;
grid minor;
xlabel('Tau');
ylabel('PCF');
title('Partial Correlation of NASDAQ Data');
legend('show');

