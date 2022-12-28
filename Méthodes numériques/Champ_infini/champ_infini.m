clear

% Constantes du probleme
eps_r = 3;
mu_r = 1;
nu_r = sqrt(eps_r*mu_r);
lambda = 2;
R = 1;
k_0 = 2*pi/lambda;

% angle d'incidence de l'onde
phi = 0;

% Ordre des sommes a calculer
N_ordre = 5;

% theta
Theta = linspace(0, 2*pi, 100);

% Declaration tableau contenant les champs à l'infini pour les differents theta
G = zeros(1, length(Theta));

% Declaration de la somme g
g = 0;

% Debut iterations
for j = 1:length(Theta)

	% Calcul de la somme g(theta) pour le theta courant
	for n = -N_ordre:N_ordre
		g = g + ( compute_sn(n, k_0*R, phi, nu_r) * (-1i)^n * exp(1i*n*Theta(j)) );
	end

	G(j) = g;
	g = 0;

end

polar(Theta, G)
xlabel("theta")
ylabel("E inf")
title("Champ à l'infini en fonction de theta")
