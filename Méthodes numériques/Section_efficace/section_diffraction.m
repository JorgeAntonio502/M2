clear 

% Constantes du probleme
eps_r = 2;
mu_r = 1;
nu_r = sqrt(eps_r*mu_r);
lambda = 2;
R = 1;

% angle d'incidence de l'onde 
phi = 0;

% Ordre des sommes à calculer
N_ordre = 5;

% Dimensions d'espace
x0 = 50;
y0 = 50;
N_points = 300;  % nombre de points selon x et y

% Creation maillage de l'espace
[x, y] = meshgrid(linspace(-x0, x0, N_points), linspace(-y0, y0, N_points));

z = x + 1i*y;
r = abs(z);
theta = angle(z);

% Creation de la zone du cylindre
flag = (r < R);

% Tableau contenant les lambda et les valeurs de sections
L = lambda : 0.5 : 7*lambda
S = zeros(1, length(L))

% Déclaration section de diffraction
Sect = 0;

for k = 1 : length(L)

	k_0 = 2*pi/L(k);
	
	for ind = 1 : N_ordre
		
		Sect = Sect + abs(compute_sn(ind, k_0*R, phi, nu_r));
		
	end
	
	S(k) = Sect;
	Sect = 0;
	
end

plot(L, S)
xlabel("lambda")
ylabel("S")
title("Section efficace en fonction de la longueur d'onde")
