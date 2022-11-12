clear 

%{
	- Le champ total est la somme du champ interieur au cylindre et du champ exterieur au cylindre :
	 u_tot = u_int + u_ext 
	
	- Le champ exterieur est lui-meme defini comme la somme des champs incident et diffractes :
	 u_ext = u_inc + u_diff
	 
	- Les expressions des champs interieur et diffracte sont :
	u_int = sum(dn.*besselj(n, k_0 * Z_r * r) .* exp(i * n .* theta))
	u_diff = sum(sn.*besselh(k_0*r) .* exp(i * n * theta))
	
	Methode generale :
	- Calculer l'ordre n a garder
	- Definir dimensions d'espace
	- Definir la zone du cylindre 
	- Definir le champ incident u_inc = exp(i*k_0*r.*sin(phi-theta))
	- Calculer le champ interieur (sur tout l'espace) 
	- Calculer le champ exterieur (sur tout l'espace) 
	- Deduire le champ total (sur tout l'espace) 
	- Tracer
%}

% Constantes du probleme
alpha_n = 1;
eps_r = 2;
mu_r = 1;
Z_r = sqrt(eps_r/mu_r);
lambda = 1;
R = 2;
k_0 = 2*pi/lambda;

% Calcul de l'ordre d'effondrement selon la loi empirique (entier superieur)
N_ordre = ceil(10*R/lambda);

% Dimensions d'espace
x0 = 10;
y0 = 10;
N_points = 100;  % nombre de points selon x et y

% Creation maillage de l'espace
[x, y] = meshgrid(linspace(-x0, x0, N_points), linspace(-y0, y0, N_points));

z = x + i*y;
r = abs(z);
theta = angle(z);

% Creation de la zone du cylindre
flag = (r < R);

% angle d'incidence de l'onde 
phi = pi/4;

% onde plane incidente sur tout l'espace
u_inc = exp(i*k_0*r.*sin(phi-theta)); 

% Calcul des coefficients dn et sn
n = -N_ordre:N_ordre; % vecteur contenant les différents n

dn = compute_dn(n, k_0*R, Z_r);
sn = alpha_n .* compute_Tn(n, k_0*R, Z_r); 

% Declaration et calcul des champs interieur et diffracte :
u_int = 0;
u_diff = 0;

for ind = 1:length(n)

	u_int = u_int .+ dn(ind).*besselj(n(ind), k_0 * Z_r .* r) .* exp(i * n(ind) .* theta);
	
	u_diff = u_diff .+ sn(ind).*besselh(n(ind), k_0 .* r) .* exp(i * n(ind) .* theta) ;
	
end

% Calcul du champ exterieur au cylindre
u_ext = u_diff + u_inc;

% Calcul de l'onde resultante finale
u_final = flag.*u_int + ~flag.*u_ext;

pcolor(x, y, real(u_final));
xlabel("x")
ylabel("y")
title("Diffraction d'une onde plane par un cylindre de rayon R")
colorbar
shading flat





