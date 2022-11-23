clear 

% Constantes du probleme
eps_r = 12;
mu_r = 1;
nu_r = sqrt(eps_r*mu_r);
lambda = 2;
R = 1;

% angle d'incidence de l'onde 
phi = 0;

% angle de diffraction pour lequel on calcule la somme
theta = 0;

% Ordre des sommes à calculer
N_ordre = 12;

% Tableaux contenant les lambda et les valeurs de sections
L = linspace(1e-3, 60, 200);
S = zeros(1, length(L));

% Déclaration section de diffraction
Sect = 0;

for k = 1 : length(L)
	
	% Calcul de k_0 pour ce tour
	k_0 = 2*pi/L(k);
	
	% Calcul de la section efficace pour le lambda courant
	for n = -N_ordre : N_ordre
		
		Sect = Sect + norm(compute_sn(n, k_0*R, phi, nu_r))**2;
		
	end
	
	% Enregistrement de la section obtenue
	S(k) = Sect;
	
	% Remise à 0 de la section
	Sect = 0;
	
end

plot(L, S)
xlabel("lambda")
ylabel("S")
title("Section efficace en fonction de la longueur d'onde")
