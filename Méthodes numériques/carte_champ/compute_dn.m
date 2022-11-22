function [res] = compute_dn(n, x, phi, nu_r)
	
	alpha_n = (-1*exp(-1i*phi)).^n;
	
	res = alpha_n .* ( ((dbesselh(n, x) .* besselj(n, x) - besselh(n, 1, x) .* dbesselj(n, x)) ./ (dbesselh(n, x) .* besselj(n, nu_r*x) - nu_r*besselh(n, 1, x) .* dbesselj(n, nu_r*x) )) );
