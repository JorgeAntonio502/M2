clear

% Constantes du problème
me = 9.1091e-31; meff = 0.067*me; e = 1.602176565e-19; hbar = 6.626e-34/2/pi;
a = 10e-9;
E0 = hbar^2*pi^2/(2*meff*a^2)/e*1e3;
V0 = 1000; Vb = V0/E0;
q0 = pi*sqrt(Vb);

% Déclaration fonctions
f = @(x) abs(cos(x/2)).*(tan(x/2) > 0); ff = @(x) f(x) - x/q0;
g = @(x) abs(sin(x/2)).*(tan(x/2) < 0); gg = @(x) g(x) - x/q0;

x = linspace(0, 50, 1000);

% Affichage
subplot(4, 1, 1), plot(x, f(x), x, x/q0) % subplot(nombre de plots, nombre de lignes, numéro de plot)
xlabel("k/2")
ylabel("|cos(k/2)| && tan(k/2) > 0") 

subplot(4, 1, 2), plot(x, g(x), x, x/q0)
xlabel("k/2")
ylabel("|sin(k/2)| && cotan(k/2) < 0") 

% Création des seeds
seed1 = [2] ; qmod1 = fsolve(ff, seed1); Emod1b = qmod1.^2/pi^2;
E1SA = Emod1b*E0;
seed2 = [5] ; qmod2 = fsolve(gg, seed2); Emod2b = qmod2.^2/pi^2; 
E2SA = Emod2b*E0;

%------- Verif Methode

Lb = 5;
NN = logspace(2, 5, 50);

for p = 1:length(NN)

	N = floor(NN(p));

	delt = Lb/N;
	xb = -Lb/2 + Lb/N * (0:N);
	vn = Vb*(abs(xb) > 0.5);
	
	nmodes = 2;
	options.disp = 0;
	ee = ones(N+1, 1);
	Lap = spdiags([ee, -2*ee ee], [-1, 0, 1], N+1, N+1);
	A = -1/pi^2 / delt^2 * Lap + spdiags(vn.', 0, N+1, N+1);
	[psi, En] = eigs(A, nmodes, 'sm', options);
	EEn(:,p) = E0*sort(diag(En));
	% sort() permet d'assurer que les deux premières lignes soient bien les deux premiers modes
	
end

%% ---------- Tracé dérivée analytique et approximation

E1SA = 42.298056780211112
E2SA = 168.1689175719088

Evrai = [E1SA; E2SA];
Evrai = repmat(Evrai, 1, length(NN));

subplot(4, 1, 3), semilogx(NN, abs(EEn - Evrai), 'LineWidth', 2)
title("Comparaison MDF et solution analytique")
xlabel("x")

%% ----------- Profil lisse

n = 5;
VA = 1;
VB = 0.5;
w = 1;

x = linspace(-3, 3, 1e3); 


%% ---------- Sparse matrix et convergence profil lisse
VA = Vb;
VB = 0;
w = 1; 

nmodes = 3;
options.disp =0;

f = @(x, n) VA + (VB - VA) * exp(-(2*x/w).^(2*n));
pqrec = @(x) VA * (abs(x) > 0.5);

Lb = 5;
NN = 100:100:3000;
logspace(2, 5, 50);

for p = 1:length(NN)

	N = NN(p);

	delt = Lb/N;
	xb = -Lb/2 + Lb/N * (0:N);
	vn = f(xb, 10);
	ee = ones(N+1, 1);
	Lap = spdiags([ee -2*ee ee], [-1, 0, 1], N+1, N+1);
	A = -1/pi^2 / delt^2 * Lap + spdiags(vn.', 0, N+1, N+1);
	[psi, En] = eigs(A, nmodes, 'sm', options);
	EEn(:,p) = sort(diag(En));
	% sort() permet d'assurer que les deux premières lignes soient bien les deux premiers modes
	
end

subplot(4, 1, 4), plot(NN, EEn, 'Linewidth', 2)

%% ---------- Sparse matrix et convergence en fonction du paramètre profil lisse
VA = Vb;
VB = 0;
w = 1; 

nmodes = 3;
options.disp = 0;

f = @(x, n) VA + (VB - VA) * exp(-(2*x/w).^(2*n));
pqrec = @(x) VA * (abs(x) > 0.5);

Lb = 5;
delt = Lb/N;
xb = -Lb/2 + Lb/N * (0:N);
nmax = 50

for n = 1:nmax

	vn = f(xb, n);
	ee = ones(N+1, 1);
	Lap = spdiags([ee -2*ee ee], [-1, 0, 1], N+1, N+1);
	A = -1/pi^2 / delt^2 * Lap + spdiags(vn.', 0, N+1, N+1);
	[psi, En] = eigs(A, nmodes, 'sm', options);
	EEn(:,p) = sort(diag(En));
	% sort() permet d'assurer que les deux premières lignes soient bien les deux premiers modes
	
end

subplot(4, 1, 4), plot(1:nmax, EEn, 'Linewidth', 2)

