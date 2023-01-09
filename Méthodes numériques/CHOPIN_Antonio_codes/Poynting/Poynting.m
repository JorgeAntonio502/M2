clear

% Constantes du probleme
eps_r = 12;
mu_r = 1;
nu_r = sqrt(eps_r*mu_r);
lambda = 2;
R = 1;
k_0 = 2*pi/lambda;

% angle d'incidence de l'onde
phi = 0;

% Ordre des sommes à calculer
N_ordre = 5 %floor(10*(R/lambda));

% Dimensions d'espace
x0 = 4;
y0 = 4;
N_points = 300;  % nombre de points selon x et y

% Creation maillage de l'espace
[x, y] = meshgrid(linspace(-x0, x0, N_points), linspace(-y0, y0, N_points));

z = x + 1i*y;
r = abs(z);
theta = angle(z);

% Creation de la zone du cylindre
flag = (r < R);

% onde plane d'incidence phi sur tout l'espace
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
u_final = flag.*u_int + ~flag.*u_ext;

%{
  Expression Poynting : P = (1/mu_r) * Im( conj(u) * diff(u) );
%}

%Calcul de la différentielle de u
Nabla_u = diff(u_final);

% Ajustement dimension de u_final pour correspondre à diff(u_final)
u_final(length(u_final), :) = [];

% Calcul du vecteur de poynting
poynting = (1/mu_r) * imag(conj(u_final) .* Nabla_u);

% Ajustement des dimensions pour correspondre à poynting
x(length(x), :) = [];
y(length(y), :) = [];

% Tracé vecteur de Poynting
pcolor(x, y, abs(poynting));
xlabel("x")
ylabel("y")
title("Vecteur de poynting")
colorbar
shading flat

