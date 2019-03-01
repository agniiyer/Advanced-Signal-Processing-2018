clc
close all
clear

load sunspot.dat
p=20;
sun = sunspot(:,2);
sun = zscore(sun);
N = length(sun(:,1));

x = zeros(N,10);

for i = 1:p
    ar = aryule(sun(1:N), i);
    x(:,i) = filter(-1*ar(1:end),1,sun);
end

E=zeros(N,p);
o = ones(1,p);
E(1,:) = (x(1,:)-o*sun(1)).^2;

for i=2:N % Can't start with index 1 because of E(i-1)
    E(i,:) = (x(i,:)-o*sun(i)).^2 + E(i-1,:);
end

MDL = log(E(N,(1:p))) + (1:p)*log(N)/N;
AIC = log(E(N,(1:p))) + (1:p)*2/N;
AIC_c = zeros(1,p);

for i=1:size(p)
    
    AIC_c(i) = AIC(i) + (2*(i))*((i)+1)/(N-(i)-1);
end

hold on;
plot(AIC,'DisplayName','AIC');
plot(MDL,'DisplayName','MDL');
plot(AIC_c,'DisplayName','AIC_c')
plot(log(E(N,:)),'DisplayName','Cumulative Error Squared');
% axis([0 20 -0.5 7]); % Overview
axis([0 20 5.8 6.5]); % Zoom
grid on;
grid minor;
xlabel('Model Order');
ylabel('Magnitude');
title(['AIC, MDL and Cumulative Error Squared from order p=0 to p=' num2str(p)]);
legend('show');
