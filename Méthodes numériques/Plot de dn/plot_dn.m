clear all

% Paramètres
N = 20;
n = -N:N;

alphan = 1;
lambda = 1;
R = 2;
eps_r = 2;
mu_r = 1;
k_0 = 2*pi/lambda;
Z_r = sqrt(eps_r/mu_r);

dn = compute_dn(n, R, Z_r);

bar(n, abs(dn))
xlabel("n")
ylabel("dn") 
