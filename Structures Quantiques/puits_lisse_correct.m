clear


% Paramètres physiques
a = 10.e-09;
a_bar = 5;
m_e = 9.1091e-31;
m_eff = 0.067 * m_e;
q_e = 1.602176565e-19;
h_bar = 6.626e-34 / 2 / pi;
E_0 = h_bar^2 * pi^2 / (2 * m_eff * a^2) / q_e * 1.e03;
V_0 = 1000 ; v_0 = V_0 / E_0;
v_A = v_0 ; v_B = 0;

% Paramètres de la simulation
n_modes = 3;
options.disp = 0;       % Nécessaire pour spécifier que la matrice 1 est une matrice creuse


% Expressions des potentiels
n_potentiel = 100:100:1000;
w_potentiel = 1;
lisse = @(x, n) v_A + (v_B - v_A) * exp(- ((2 * x) / w_potentiel).^(2 * n));
rectangulaire = @(x) v_0 * (abs(x) > 0.5);

EE_lisse = [];
EE_rect = [];

%% Comparaison avec le potentiel rectangle en fonction de N
%{
NN = logspace(2, 3);
for i=1:length(NN)
  N = floor(NN(i));
  dx = a_bar / N;
  x = - a_bar / 2 + dx * (0:N);
  
  ee = ones(N+1, 1);
  Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);	% spdiags donne une matrice creuse : une matrice symbolique composée des trois diagonales
  
  for p=1:length(n_potentiel)
    v = lisse(x, n_potentiel(p));
    A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);
    [Psi, E] = eigs(A, n_modes, 'sm', options);
    
    EE_lisse(:, i, p) = sort(diag(E));
  end
  
  v = rectangulaire(x);
  A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);
  [Psi, E] = eigs(A, n_modes, 'sm', options);
  
  EE_rect(:, i) = sort(diag(E));
end

% Figures
figure;
title("Comparaison des potentiels en fonction de N et n");
subplot(311) ; plot(NN, EE_lisse(:,:,1), NN, EE_rect);
subplot(312) ; plot(NN, EE_lisse(:,:,5), NN, EE_rect);
subplot(313) ; plot(NN, EE_lisse(:,:,10), NN, EE_rect);

%}


%% Comparaison avec le potentiel rectangle en fonction de n_potentiel
N = 3000;
dx = a_bar / N;
x = - a_bar / 2 + dx * (0:N);

ee = ones(N+1, 1);
Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);	% spdiags donne une matrice creuse : une matrice symbolique composée des trois diagonales

for p=1:length(n_potentiel)
  v = lisse(x, n_potentiel(p));
  A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);
  [Psi, E] = eigs(A, n_modes, 'sm', options);
  
  EE_lisse(:, p) = E_0 * sort(diag(E));
end

v = rectangulaire(x);
A = -1 / (pi * dx)^2 * Lap + spdiags(v.', 0, N+1, N+1);
[Psi, E] = eigs(A, n_modes, 'sm', options);

EE_rect = repmat(E_0 * sort(diag(E)), 1, length(n_potentiel));

% Figures
figure;
subplot(211), plot(n_potentiel, EE_lisse, n_potentiel, EE_rect);
xlabel("n_{potentiel}"), ylabel("E");
title("Énergies");

subplot(212), plot(n_potentiel, abs(EE_lisse - EE_rect));
xlabel("n_{potentiel}"), ylabel("Delta E");
title("Différence des énergies");

%% PQ multi-rectangulaire
pqm = @(x) v0*(abs(x)>=0.5)+v0/2*(x>=0 & x < 5);

Lb = 5; delta = Lb/N; xb = -Lb/2 + Lb/N * (0:N);

% Profil
vn = pqm(xb);

am2 = -1/12/delta^2;
ap2 = am2;
am1 = 4/3/delta^2;
ap1 = am1;
a0 = -5/2/delta^2;

nmodes = 3;
options.disp = 0;
ee = ones(N+1:1); Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
A = -1/pi^2/delta^2*Lap+spdiags(v.', 0, N+1, N+1);
%Nee = ones(N+1, 1); Lap = spdiags(am2)

[psi, En] = eigs(A_nmodes, 'sm', options); En = sort(diag(En));

plot(xb, pqm(xb)/v0, 'Linwidth', 2);
hold on; pp = 2;
plot(xb, 5*(1-psi(:,pp)/max(abs(psi(:,pp)))), 'Linewidth', 2)


