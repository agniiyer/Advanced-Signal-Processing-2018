function [y,e,w] = sign_of_sign(x,z,u,order)
    start = order+1;
    nW = order-1;
    w(:,start-1) = zeros(nW,1);
    y(start-1) = 0;
for i=start:length(x)+1
y(i-1) = transpose(w(:,i-1))*flipud(x(i-nW:i-1)); e(i-1) = z(i-1)-y(i-1);
w(:,i) = w(:,i-1)+u*sign(e(i-1))*sign(flipud(x(i-nW:i-1)));
end
end