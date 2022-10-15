clear

%Paramètres :
lambda = 1
R = 2
N = 20
eps_r = 2
mu_r = 1
k_0 = 2*pi/lambda
n = -N:N
Z_r = sqrt(eps_r/mu_r)

Kn = (dbessely(n, k_0*R) .* besselj(n, k_0*Z_r*R) - Z_r*bessely(n, k_0*R).*dbesselj(n, k_0*Z_r*R)) ./ (dbesselj(n, k_0*R).*besselj(n, k_0*Z_r*R) - Z_r*besselj(n, k_0*R).*dbesselj(n, k_0*Z_r*R))

Tn = -1 ./ (1 + i*Kn)

bar(n, abs(Tn)) 
pause





