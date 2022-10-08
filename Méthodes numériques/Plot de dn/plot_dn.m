clear

N = 20
n = 0 : N

alphan = 1
lambda = 1
k_0 = 2*pi/lambda
R = 5
r = 1

mu_r = 1
eps_r = 2

Z_r = sqrt(eps_r/mu_r)

dn = alphan * ((dbesselh(n, k_0*R) .* besselj(n, k_0*r) - besselh(n, 1, k_0*R) .* dbesselj(n, k_0*r)) ./ (dbesselh(n, k_0*R) .* besselj(n, k_0*mu_r*R) - Z_r*besselh(n, 1, k_0*R) .* dbesselj(n, k_0*mu_r*R) ))

abs(dn)
bar(n, abs(dn))
pause
