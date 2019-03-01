load sunspot.dat
sun = sunspot(:,2); % Given that sunspot data is in the second column.

% Coefficients for every order upto 10:
ar1 = aryule(sun,1);
ar2 = aryule(sun,2);
ar3 = aryule(sun,3);
ar4 = aryule(sun,4);
ar5 = aryule(sun,5);
ar6 = aryule(sun,6);
ar7 = aryule(sun,7);
ar8 = aryule(sun,8);
ar9 = aryule(sun,9);
ar10 = aryule(sun,10);

hold on
grid on
grid minor
plot(ar1,'DisplayName','1');
plot(ar2,'DisplayName','2');
plot(ar3,'DisplayName','3');
plot(ar4,'DisplayName','4');
plot(ar5,'DisplayName','5');
plot(ar6,'DisplayName','6');
plot(ar7,'DisplayName','7');
plot(ar8,'DisplayName','8');
plot(ar9,'DisplayName','9');
plot(ar10,'DisplayName','10');
xlabel('AR Order')
ylabel('Coefficients')
title('Yule Walker coefficients for sunspot data upto model order p=10');
legend('show');