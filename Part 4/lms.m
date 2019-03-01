function [y_est, e, coeffs] = lms(x, z, u, order)
    N = length(x);
    coeffs = zeros(order, N-1);
    y_est = zeros(N, 1);
    e = zeros(N, 1);

    for i = order+1:N
        x_hat = x(i:-1:i-order+1);
        y_est(i) = (coeffs(:, i-order).') * x_hat;
        e(i) = z(i) - y_est(i);
        coeffs(:, i-order+1) = coeffs(:, i-order) + u * e(i) * x_hat;
    end
end