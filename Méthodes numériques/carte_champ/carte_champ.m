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
eps_r = 12;
mu_r = 1;
nu_r = sqrt(eps_r*mu_r);
lambda = 9.2417;
R = 1;
k_0 = 2*pi/lambda;

% angle d'incidence de l'onde 
phi = 0;

% Ordre des sommes à calculer
N_ordre = 5;

% Dimensions d'espace
x0 = 3;
y0 = 3;
N_points = 300;  % nombre de points selon x et y

% Creation maillage de l'espace
[x, y] = meshgrid(linspace(-x0, x0, N_points), linspace(-y0, y0, N_points));

z = x + 1i*y;
r = abs(z);
theta = angle(z);

% Creation de la zone du cylindre
flag = (r < R);

% onde plane d'incidence phisur tout l'espace
u_inc = exp(1i*k_0*r.*sin(phi-theta)); 

% Calcul des coefficients dn et sn

n = -N_ordre:N_ordre; % vecteur contenant les différents n

dn = compute_dn(n, k_0*R, phi, nu_r);
sn = compute_sn(n, k_0*R, phi, nu_r); 

% Declaration et calcul des champs interieur et diffracte :
u_int = 0;
u_diff = 0;

for ind = 1:length(n)

	u_int = u_int + dn(ind).*besselj(n(ind), k_0 * nu_r .* r) .* exp(1i * n(ind) .* theta);
	
	u_diff = u_diff + sn(ind).*besselh(n(ind), k_0 .* r) .* exp(1i * n(ind) .* theta) ;
	
end

% Calcul du champ exterieur au cylindre
u_ext = u_diff + u_inc;

% Calcul de l'onde resultante finale
u_final = flag.*u_int .+ ~flag.*u_ext;

subplot(221), pcolor(x, y, real(u_inc));
xlabel("x")
ylabel("y")
title("Champ incident")
colorbar
shading flat

subplot(222), pcolor(x, y, real(flag.*u_int));
xlabel("x")
ylabel("y")
title("Champ intérieur")
colorbar
shading flat

subplot(223), pcolor(x, y, real(~flag.*u_ext));
xlabel("x")
ylabel("y")
title("Champ extérieur")
colorbar
shading flat

subplot(224), pcolor(x, y, real(u_final));
xlabel("x")
ylabel("y")
title("Champ total")
colorbar
shading flat

