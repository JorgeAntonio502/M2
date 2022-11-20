clear

% Constantes
a = 10e-9;
me = 9.1091e-31;
meff = 0.067*me;
e = 1.620176565e-19;
hbar = 6.626e-34/2/pi;
E0 = hbar^2 * pi^2 / (2*meff*a^2)/e*1e3;
V0 = logspace(3, 7, 100); % logspace(a, b c) : vecteur de taille c de 10^a à 10^b
v0 = V0/E0;

nmodes = 3;
options.disp = 0;

% Paramètres
Lb = 5;
N = 10e2;
delt = Lb/N;
xb = -Lb/2 + Lb/N*(0:N);

ee = ones(N+1, 1);
Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);

% Boucle

EEn = []; % Matrice vide

for p = 1 : length(v0)
	vn = v0(p)*(abs(xb)>0.5);
	A = -1/pi^2 / delt^2 * Lap + spdiags(vn.', 0, N+1, N+1);
	[psi, En] = eigs(A, nmodes, 'sm', options); % 'sm' : les plus petites
	En = diag(En);
	EEn = [EEn En];
end

plot(v0, EEn, 'linewidth', 2)


% ones(n,p) : matrice de 1 de taille nxp ===> ones(N, 1) : vecteur colonne de taille N
% diag(A, n) : diagonalise A selon diagonale n ====> diag(ones(N, 1)) : diagolalisé selon diagonale principale. diag(ones(N, 1), 1) : diagonalisé selon diagonale supérieure. diag(ones(N, 1), -1) : diagonalisé selon diagonale inférieure


