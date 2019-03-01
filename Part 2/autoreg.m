N=10000;
a1 = 5.*rand(N,1)-2.5;
a2 = 3.*rand(N,1)-1.5;
x = rand(1,N);

good = []; % Vectors hold stable and unstable coefficients.
bad = [];

for i =1:N
    if(a1(i)+a2(i)<1) && (a2(i)-a1(i)<1) && (a2(i)>-1) && (a2(i)<1)
        good = [good [a1(i);a2(i)]]; % Concatenate the end of the vector with new values.
    else
        bad = [bad [a1(i);a2(i)]];
    end
end

hold on;
plot(good(1,:),good(2,:),'*','DisplayName','Stable'); % a1 in first row, a2 in second row.
plot(bad(1,:),bad(2,:),'*','DisplayName','Unstable');
grid on;
grid minor;
legend
xlabel('a1');
ylabel('a2');
title('Stable and unstable coefficients for N = 10000');
legend('show');