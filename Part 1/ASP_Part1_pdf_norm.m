clear all
close all
clc

% PDF tends to 0.1 as N (number of samples) is made larger.

x = rand(1,1000);
[y,group] = hist(x); % Returns bin limits and number of elements in each bin
bar(group,(y/1000),'DisplayName','Estimated PDF'); % Uses same bins but normalizes number of elements
xlabel('x')
ylabel('Probability')
hold on
line([0 1],[.1 .1],'DisplayName','Theoretical PDF', 'Color', 'r', 'LineWidth', 2); % ([x1 x2],[y1 y2])
legend('show')
grid on
grid minor