function [res] = compute_sn(n, x, phi, nu_r)
	
	alpha_n = (-1*exp(-1i*phi)).^n;
	
	Kn = (dbessely(n, x) .* besselj(n, nu_r*x) - nu_r*bessely(n, x).*dbesselj(n, nu_r*x)) ./ (dbesselj(n, x).*besselj(n, nu_r*x) - nu_r*besselj(n, x).*dbesselj(n, nu_r*x));
	
	res = alpha_n .* ( -1 ./ (1 + i*Kn) );
