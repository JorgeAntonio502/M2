clear all

N = 30
n = 0 : N

alphan = 1
lambda = 1
k_0 = 2*pi/lambda
R = 2

mu_r = 1
eps_r = 2

Z_r = sqrt(eps_r/mu_r)

dn = alphan * ((dbesselh(n, k_0*R) .* besselj(n, k_0*R) - besselh(n, 1, k_0*R) .* dbesselj(n, k_0*R)) ./ (dbesselh(n, k_0*R) .* besselj(n, k_0*Z_r*R) - Z_r*besselh(n, 1, k_0*R) .* dbesselj(n, k_0*Z_r*R) ))

abs(dn)
bar(n, abs(dn))
pause
