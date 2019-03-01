function w_sc = lms_diffgain(gain,x_del,x,b)
[~, ~, w] = lms(x_del, x, gain, 2);
w_sc = w.*sqrt(sum(b.*b));
end