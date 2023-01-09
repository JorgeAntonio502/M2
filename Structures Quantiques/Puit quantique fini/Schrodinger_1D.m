clear

% Constantes
a = 10e-9;
me = 9.1091e-31;
meff = 0.067*me;
e = 1.620176565e-19;
hbar = 6.626e-34/2/pi;
E0 = hbar^2 * pi^2 / (2*meff*a^2)/e*1e3;
V0 = 1000;
v0 = V0/E0;

% Paramètres
Lb = 5;
N = 1000;
delt = Lb/N;
xb = -Lb/2 + Lb/N*(0:N);
vn = v0*(abs(xb)>0.5);

nmodes = 7;
B = -2*diag(ones(N+1, 1)) + diag(ones(N, 1), 1) + diag(ones(N, 1), -1);
A = -1/pi^2 / delt^2 * B + diag(vn);
[psi, En] = eigs(A, nmodes, 'sm'); % 'sm' : les plus petites
En = E0*diag(En);

% ones(n,p) : matrice de 1 de taille nxp ===> ones(N, 1) : vecteur colonne de taille N
% diag(A, n) : diagonalise A selon diagonale n ====> diag(ones(N, 1)) : diagolalisé selon diagonale principale. diag(ones(N, 1), 1) : diagonalisé selon diagonale supérieure. diag(ones(N, 1), -1) : diagonalisé selon diagonale inférieure

% Tracé figure
figure;
subplot(321); plot(xb, psi(:,7));
subplot(322); plot(xb, psi(:,6));
subplot(323); plot(xb, psi(:,5));
subplot(324); plot(xb, psi(:,4));
subplot(325); plot(xb, psi(:,3));
subplot(326); plot(xb, psi(:,2));
