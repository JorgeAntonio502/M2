function [res] = compute_en(n, x, phi, nu_r, eps_1, eps_2)

	d_n = compute_dn(n, x, phi, nu_r);

	res = d_n .* ( ((dbesselj(n, sqrt(eps_2)*x) .* besselj(n, sqrt(eps_1)*x) - sqrt(eps_1/eps_2)*besselj(n, sqrt(eps_2)*x) .* dbesselj(n, sqrt(eps_1)*x)) ./ (besselh(n, sqrt(eps_2)*x) .* dbesselj(n, sqrt(eps_2)*x) - dbesselh(n, sqrt(eps_2)*x) .* besselj(n, sqrt(eps_2)*x) )) );
