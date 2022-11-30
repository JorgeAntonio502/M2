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

% Paramètres de la simulation
l = 5;
N = 1000;
dx = l / N;
x = - l / 2 + dx * (0:N);

n_modes = 7;

% Construction des tableaux
v = v_0 * diag((abs(x) > 0.5));
B = - 2 * diag(ones(N+1, 1)) + diag(ones(N, 1), 1) + diag(ones(N, 1), -1);
A = - B / (pi * dx)^2 + v;
[Psi, E] = eigs(A, n_modes, 'sm');
E = E_0 * diag(E)


% Figures
figure;
subplot(321) ; plot(x, Psi(:, 7));
subplot(322) ; plot(x, Psi(:, 6));
subplot(323) ; plot(x, Psi(:, 5));
subplot(324) ; plot(x, Psi(:, 4));
subplot(325) ; plot(x, Psi(:, 3));
subplot(326) ; plot(x, Psi(:, 2));
