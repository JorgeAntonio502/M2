clear

% Constantes
a = 10e-9;
me = 9.1091e-31;
meff = 0.067*me;
e = 1.620176565e-19;
hbar = 6.626e-34/2/pi;
E0 = hbar^2 * pi^2 / (2*meff*a^2)/e*1e3;
V0 = logspace(3, 7, 100); % logspace(a, b c) : vecteur de taille c de 10^a à 10^b

% Normalisation du potentiel
v0 = V0/E0;

% Pour potentiel lisse
w_potentiel = 1;
v_A = v0 ; v_B = 0;

nmodes = 3;
options.disp = 0;

% Paramètres
Lb = 5;
N = 10e2;
delt = Lb/N;
xb = -Lb/2 + Lb/N*(0:N);

ee = ones(N+1, 1);
Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);

% Fonctions des différents types de potentiels V(x)
lisse = @(x, n, vA, v_B) v_A + (v_B - v_A) * exp(- ((2 * x) / w_potentiel).^(2 * n));
rectangulaire = @(x, v0) v0 * (abs(x) > 0.5);

EEn = []; % Matrice vide

% Boucle
for p = 1 : length(v0)

  % Définition de V(x)
	vn = rectangulaire(xb, v0(p));

  % Définition matrice à résoudre numériquement
	A = -1/pi^2 / delt^2 * Lap + spdiags(vn.', 0, N+1, N+1);

  % Vecteurs propres (fct d'onde psi) et valeurs propres (energie En)
	[psi, En] = eigs(A, nmodes, 'sm', options); % 'sm' : les plus petites

  % diag(A, n) : diagonalise A selon diagonale n
	En = diag(En);

  % MAJ de EEn
	EEn = [EEn En];
end

% Dénormalisation
V0 = E0*v0;
EEn = E0*EEn;

plot(V0, EEn, 'linewidth', 2)
title("Energies propres d'un puit infini en fonction du potentiel")
xlabel("V0")
ylabel("Energie [meV]")
