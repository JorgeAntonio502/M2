clear

% Paramètres
N = 20;
n = -N:N;

% Constantes du probleme
eps_1 = 4;
eps_2 = 2;
mu_r = 1;
nu_r1 = sqrt(eps_1*mu_r);
nu_r2 = sqrt(eps_2*mu_r);
lambda = 2;
R_1 = 1;
R_2 = 2;
k_0 = 2*pi/lambda;

% angle d'incidence de l'onde
phi = pi/5;

% Ordre des sommes à calculer
N_ordre = 5;

e_n = compute_en(n, R_1, phi, nu_r1, eps_1, eps_2);

bar(n, abs(e_n))
xlabel("n")
ylabel("en")
