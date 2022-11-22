clear 

% Constantes du probleme
eps_r = 2;
mu_r = 1;
nu_r = sqrt(eps_r*mu_r);
lambda = 2;
R = 1;
k_0 = 2*pi/lambda;

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

% Déclaration de la somme g
g = 0;

% Calcul de la somme g
for ind = 1 : N_ordre
	g = g + ( compute_sn(ind, k_0*R, phi, nu_r) * (-1i)^ind * exp(1i*ind*theta) );
end

% Calcul du champ à l'infini
u_inf = ( exp(1i*k_0*r)./sqrt(k_0*r) ) .* g;

pcolor(x, y, real(u_inf))
xlabel("x")
ylabel("y")
title("Champ à l'infini")
colorbar
shading flat
