function [res] = dbesselh(n, x)
	%calcul de la dérivée de Bessel H
	res = (besselh(n-1, x) - besselh(n+1, x))/2;
