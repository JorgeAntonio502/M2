clear


% Paramètres physiques
a = 10.e-09;
m_e = 9.1091e-31;
m_eff = 0.067 * m_e;
q_e = 1.602176565e-19;
h_bar = 6.626e-34 / 2 / pi;
E_0 = h_bar^2 * pi^2 / (2 * m_eff * a^2) / q_e * 1.e03;
V_0 = 1000;
v_0 = V_0 / E_0;


% Expression du potentiel
n_potentiel = 1000;
w_potentiel = 1;
lisse = @(x) v_0 * (1 - exp(- ((2 * x) / w_potentiel).^(2 * n_potentiel)));


% Paramètres de la simulation
a_bar = 5;
NN = 1000:1000:10000;

n_modes = 1;
options.disp = 0;


% Initialisation des tableaux
EE3 = [];
EE5 = [];


% Calcul des énergies
for p = 1:length(NN)
  N = floor(NN(p));
  dx = a_bar / N;
  x = - a_bar / 2 + dx * (0:N);
  v = lisse(x);

  ee = ones(N+1, 1);
  Lap3 = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
  Lap5 = spdiags([-1 / (12 * dx^2) * ee, 4 / (3 * dx^2) * ee, -5 / (2 * dx^2) * ee, 4 / (3 * dx^2) * ee, -1 / (12 * dx^2) * ee], [-2 -1 0 1 2], N+1, N+1);

  A3 = -1 / (pi * dx)^2 * Lap3 + spdiags(v.', 0, N+1, N+1);
  A5 = -1 / pi^2 * Lap5 + spdiags(v.', 0, N+1, N+1);

  [Psi, E] = eigs(A3, n_modes, 'sm', options);
  %E3_bar = [E3_bar, sort(diag(E))];
  EE3(:, p) = E_0 * sort(diag(E));

  [Psi, E] = eigs(A5, n_modes, 'sm', options);
  %E5_bar = [E5_bar, sort(diag(E))];
  EE5(:, p) = E_0 * sort(diag(E));
end

dE = abs(EE3 - EE5);


% Présentation des résultats
figure;
subplot(211);
hold on, plot(NN, EE3, ";3PS;"), plot(NN, EE5,";5PS;"), hold off;
title("Énergie du mode fondamental");
xlabel("N"), ylabel("E");

subplot(212), plot(NN, dE);
title("Différence des énergies du mode fondamental");
xlabel("N"), ylabel("Delta E");

