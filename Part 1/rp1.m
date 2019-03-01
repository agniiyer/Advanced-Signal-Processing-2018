function v=rp1(M,N)
    a=0.02;
    b=5;
    Mc=ones(M,1)*b*sin((1:N)*pi/N); % VECTORIZED: (1:N) means there is a loop filling values in the vector Mc from position 1 to N.
    Ac=a*ones(M,1)*[1:N];
    v=(rand(M,N)-0.5).*Mc+Ac; % If you just plot v, you get the entire ensemble!