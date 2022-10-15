function [res] = compute_Tn(n, R)
	eps_r = 2;
	mu_r = 1;
	lambda = 1;
	Z_r = sqrt(eps_r/mu_r);
	lambda = 1;
	k_0 = 2*pi/lambda;
	
	Kn = (dbessely(n, k_0*R) .* besselj(n, k_0*Z_r*R) - Z_r*bessely(n, k_0*R).*dbesselj(n, k_0*Z_r*R)) ./ (dbesselj(n, k_0*R).*besselj(n, k_0*Z_r*R) - Z_r*besselj(n, k_0*R).*dbesselj(n, k_0*Z_r*R));
	
	res = -1 ./ (1 + i*Kn);
