function [y,e,w] = n_lms(x,d,u,order)
start = order+1;
nw = order-1;
w(:,start-1) = zeros(nw,1);
y(start-1)=0;
for i=start:length(x)+1
    uA = u/(0.001+x(i-order:i-1)'*x(i-order:i-1)); %gear shifting
    y(i-1) = transpose(w(:,i-1))*flipud(x(i-nw:i-1));
    e(i-1) = d(i-1)-y(i-1);
    w(:,i) = w(:,i-1)+uA*e(i-1)*flipud(x(i-nw:i-1));
end 
end