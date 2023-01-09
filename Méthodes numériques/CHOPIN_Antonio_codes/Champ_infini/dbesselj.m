function [res] = dbesselj(n, x)
	%calcul de la dérivée de Bessel J
	res = (besselj(n-1, x) - besselj(n+1, x))/2;
