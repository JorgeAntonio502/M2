clear 

%{
	Tracé d'une carte de champ représentant une onde plane incidente diffractée par un cylindre de rayon R :
	
	- Le champ total à afficher est la somme du champ intérieur au cylindre et du champ extérieur au cylindre :
	 u_tot = u_int + u_ext 
	
	- Le champ extérieur est lui-même défini comme la somme des champs incident et diffractés :
	 u_ext = u_inc + u_diff
	 
	- Les expressions des champs intérieur et diffracté sont :
	u_int = sum(dn.*besselj(n, k_0 * Z_r * r) .* exp(i * n .* theta))
	u_diff = sum(sn.*besselh(k_0*r) .* exp(i * n * theta))
	
	Méthode générale :
	- Calculer l'ordre n à garder (TP de détermination d'ordre d'effondrement)
	- Définir dimensions d'espace
	- Définir la zone du cylindre 
	- Définir le champ incident u_inc = exp(i*k_0*r.*sin(phi-theta))
	- Calculer le champ intérieur (sur tout l'espace) 
	- Calculer le champ extérieur (sur tout l'espace) 
	- Déduire le champ total (sur tout l'espace) 
	- Tracer
%}

% Constantes du problème
alpha_n = 1;
eps_r = 2;
mu_r = 1;
Z_r = sqrt(eps_r/mu_r);
lambda = 1;
R = 2;
k_0 = 2*pi/lambda;

% Calcul de l'ordre d'effondrement selon loi empirique
N_ordre = ceil(10*R/lambda);

% Dimensions d'espace
x0 = 10;
y0 = 10;
N_points = 100;  % nombre de points selon x et y

% Création maillage
[x, y] = meshgrid(linspace(-x0, x0, N_points), linspace(-y0, y0, N_points));

z = x + i*y;
r = abs(z);
theta = angle(z);

% Création de la zone du cylindre
flag = r < R;

% angle d'incidence de l'onde 
phi = pi/3;
% onde plane incidente
u_inc = exp(i*k_0*r.*sin(phi-theta)); 

% Déclaration des champs intérieurs et extérieurs au cylindre :
u_int = 0;
u_ext = 0;

% Calcul des coefficients dn et sn
%dn = compute_dn(n, k_0*R, Z_r);
%sn = alpha_n * compute_Tn(n, k_0*R, Z_r); 

% Calcul des champs extérieurs et intérieurs

%u_int = 
%u_ext = % = u_inc + u_diff

% Calcul de l'onde résultante finale
%u_final = flag.*u_int + ~flag.*u_ext;

pcolor(x, y, real(u_inc));
xlabel("x")
ylabel("y")
title("Diffraction d'une onde plane par un cylindre de rayon R")
colorbar
shading flat





