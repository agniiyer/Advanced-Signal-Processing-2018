function [y, e, w] = lms_gs(x,z,u,order)
start = order+1;
uA = u;
nW = order-1;
w(:,start-1) = zeros(nW,1);
y(start-1) = 0;
for i=start:length(x)+1
    y(i-1) = transpose(w(:,i-1))*flipud(x(i-nW:i-1));
    e(i-1) = z(i-1)-y(i-1);
    if e(i-1)<e(i-2)
        uA = uA*0.8;
    else
        uA = uA*1.2;
    end
    w(:,i) = w(:,i-1)+uA*e(i-1)*flipud(x(i-nW:i-1));
end
end