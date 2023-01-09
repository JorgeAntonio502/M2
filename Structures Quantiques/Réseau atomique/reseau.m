clear

% Constantes du problème
a = 10e-9;
me = 9.1091e-31; meff = 0.067*me; e = 1.602176565e-19; hbar = 6.626e-34/2/pi;
E0 = hbar^2*pi^2/(2*meff*a^2)/e*1e3;
V0 = 400;

% Potentiel normalisé
V0b = V0/E0;

% Distance normalisée entre les puits
d=linspace(0.01, 10, 100)*1e-9;

nmodes = 50;
options.disp = 0;
N = 1e4;

% Nombre de puits quantiques dans le réseau
Npq = 3;

% Domaine d'espace normalisées. Marge de 10 à gauche et à droite
xbi = -10;
xbf = (Npq-1)*(1+max(d)/a)+1+10;
delt = (xbf-xbi)/N;
xb = xbi + delt*(0:N);

% Génération du réseau de puits quantiques
msq = @(x, a, d) (x > 0 & x <= a); % Masque
for p = 2:Npq
	msq = @(x, a, d) msq(x, a, d) + (x >= (p-1)*(a+d) & x <= (p-1)*(a+d)+a);
end
msqpq = @(x, a, d) 1 - msq(x, a, d); % Masque des puits quantiques

% Boucle principale sur les distances. Différences Finies 3PS avec mateices creuses
for pp = 1:length(d)

  pp

  % Création potentiel pour ce tour
	vn = V0b*msqpq(xb, 1, d(pp)/a);

  %Création des sparse matrix (matrices creuses)
  % spdiags(B, d, m, n), matrice (m,n) diagonale à partir des colonnes de B projetées sur diagonales d
  % B doit avoir m lignes

	ee = ones(N+1,1); % Matrices colonnes de taille N+1
	Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);

  % v.' transposé
  % v' transposé conjugué
	A = -1/pi^2/delt^2*Lap+spdiags(vn.', 0, N+1, N+1);

  % Calcul de la fonction psi et de l'énergie (valeurs et vecteurs propres)
	[psi, En] = eigs(A, nmodes, 'sm', options);
	En = diag(En);

  % Suppression des solutions non physiques
	En(En>V0b) = nan;

  % Stockage énergie (+ dénormalisation)
	EE(:,pp) = En*E0;
end

% Affichage
plot(d,EE, 'Linewidth', 2)
title("Energies propres du réseau en fonction de la distance inter-puits")
xlabel("Distance entre les puits du réseau (m)")
ylabel("Energie (meV)")
grid
