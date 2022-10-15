clear all 

% Constantes du problème
eps_r = 2
mu_r = 1
lambda = 1
R = 2
k_0 = 2*pi/lambda

% Dimensions du plot
x0 = 6
y0 = 6
N = 100  % nombre de valeurs identiques selon x et y

% angle d'incidence phi de l'onde 
phi = pi/4

% Création maillage
[x, y] = meshgrid(linspace(-x0, x0, N), linspace(-y0, y0, N));

z = x + i*y;
r = abs(z);
theta = angle(z);

% Création de la zone du cylindre
flag = r < R;

% onde incidente
u_inc = exp(i*k_0*r.*sin(phi-theta));

% onde complémentaire (somme)
u_comp = 0;
for n = 0:N
	u_comp = u_comp + compute_Tn(n, R)*besselh(n, k_0*r)*exp(i*n*theta);
end        

u_final = flag.*u_inc + ~flag.*u_comp;

rr = r(:)'

pcolor(x, y, abs(u_inc))
pause






