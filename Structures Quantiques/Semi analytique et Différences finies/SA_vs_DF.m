clear


% Paramétrisation
me = 9.1091e-31;
meff = 0.067 * me;
qe = 1.602176565e-19;
hbar = 6.626e-34 / (2 * pi);
a = 10.e-09;
E_0 = hbar^2 * pi^2 / (2 * meff * a^2) / qe * 1.e03;
V_0 = 1000;
V_0_bar = V_0 / E_0;
q0 = pi * sqrt(V_0_bar);



%%%%%%%%%%%%%%%%%%%%%%%%%
% Méthode semi-analytique
%%%%%%%%%%%%%%%%%%%%%%%%%

% Déclaration des fonctions
f = @(x) abs(cos(x / 2)) .* (tan(x / 2) > 0);	% Cas +
ff = @(x) f(x) - x/q0;

g = @(x) abs(sin(x / 2)) .* (tan(x / 2) < 0);	% Cas -
gg = @(x) g(x) - x / q0;

% Les guesses
seed_f = [2.6];
seed_g = [5];

% Résolution des équations
qmod1_SA = fsolve(ff, seed_f);
qmod2_SA = fsolve(gg, seed_g);


% Détermination des énergies
Emod1bar_SA = qmod1_SA.^2 / pi^2;
Emod2bar_SA = qmod2_SA.^2 / pi^2;

% Dénormalisation
Emod1_SA = Emod1bar_SA * E_0
Emod2_SA = Emod2bar_SA * E_0




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Méthode des différences finies
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Paramètres
NN = logspace(2,5,50);
a_bar = 5;
n_modes = 2;
options.disp = 0;       % Nécessaire pour spécifier que la matrice 1 est une matrice creuse

EEn = [];

% Calcul des énergies
for n=1:length(NN)

  % Nombre de points pour ce tour
  N = floor(NN(n));

  % Déduction paramètres d'espace
  dx = a_bar / N;
  x = - a_bar / 2 + dx * (0:N);

  % Définition potentiel
  v = V_0_bar * (abs(x) > 0.5);

  % Création matrices creuses
  ee = ones(N+1, 1);
  Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);	% spdiags donne une matrice creuse : une matrice symbolique composée des trois diagonales
  A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);

  % Calcul fonction d'ondes et énergies
  [Psi, E] = eigs(A, n_modes, 'sm', options);

  % Stockage des résultats obtenus
  EEn(:, n) = E_0 * sort(diag(E)); % sort trie les éléments par ordre croissant
end


%% Comparaison

% Création de la matrice des énergies par la MSA
EE_SA = repmat([Emod1_SA ; Emod2_SA], 1, length(NN));
% repmat(A, n, m) crée matrice où A se répète n par m fois


%% Représentation

% Figure
subplot(211), loglog(NN,abs(EEn-EE_SA),'Linewidth',1);
title("Comparaison MSA et MDF - échelles logarithmiques");

subplot(212),semilogx(NN,abs(EEn-EE_SA),'Linewidth',1);
title("Comparaison MSA et MDF - semilogx");
