clear all

% Paramètres
N = 20;
n = -N:N;

lambda = 2;
R = 1;
eps_r = 2;
mu_r = 1;
k_0 = 2*pi/lambda;
nu_r = sqrt(eps_r/mu_r);
phi = 0;

dn = compute_dn(n, R, phi, nu_r);

bar(n, abs(dn))
xlabel("n")
ylabel("dn")
