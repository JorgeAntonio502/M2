function [res] = compute_dn(n, R, Z_r)
	alphan = 1;
	eps_r = 2;
	mu_r = 1;
	lambda = 1;
	lambda = 1;
	k_0 = 2*pi/lambda;
	
	res = alphan * ((dbesselh(n, k_0*R) .* besselj(n, k_0*R) - besselh(n, 1, k_0*R) .* dbesselj(n, k_0*R)) ./ (dbesselh(n, k_0*R) .* besselj(n, k_0*Z_r*R) - Z_r*besselh(n, 1, k_0*R) .* dbesselj(n, k_0*Z_r*R) ))
