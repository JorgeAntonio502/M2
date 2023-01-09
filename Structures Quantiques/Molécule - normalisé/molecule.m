clear


% Paramètres physiques
a = 1.e-09;
m_e = 9.1091e-31;
m_eff = 0.067 * m_e;
q_e = 1.602176565e-19;
h_bar = 6.626e-34 / 2 / pi;
E_0 = h_bar^2 * pi^2 / (2 * m_eff * a^2) / q_e * 1.e03;
V_0 = 400;
v_0 = V_0 / E_0;


% Paramètres de la simulation
a_bar = 5.;
N = 6000;
n_modes = 4;


% Initialisation des tableaux
dd_bar = linspace(1., 50., 100);
ll_bar = dd_bar + 3 * a_bar;
EE_bar = [];


% Calcul des énergies
for p = 1:length(dd_bar)
   EE_bar(:, p) = PQ_double_rect(v_0, a_bar, N, ll_bar(p), n_modes, dd_bar(p));
end


% Visualisation d'un mode
p1 = 90;
EE_p1 = Psi_p1 = v_p1 = [];
[EE_p1, Psi_p1, v_p1] = PQ_double_rect(v_0, a_bar, N, ll_bar(p1), n_modes, dd_bar(p1));
x_p1 = -ll_bar(p1) / 2. + ll_bar(p1) / N * (0:N);

p2 = 5;
EE_p2 = Psi_p2 = v_p2 = [];
[EE_p2, Psi_p2, v_p2] = PQ_double_rect(v_0, a_bar, N, ll_bar(p2), n_modes, dd_bar(p2));
x_p2 = -ll_bar(p2) / 2. + ll_bar(p2) / N * (0:N);

% Dénormalisations
dd = dd_bar * a;
EE = EE_bar * E_0;
EE_p1 = EE_p1 * E_0;
EE_p2 = EE_p2 * E_0;
v_p1 = v_p1 * E_0;
v_p2 = v_p2 * E_0;
EE(EE > V_0) = nan;
EE_p1(EE_p1 > V_0) = nan;
EE_p2(EE_p2 > V_0) = nan;


%Présentation des résultats
figure;
subplot(311), plot(dd, EE), title("Énergies des quatre premiers modes en fonction de d"), xlabel("d [m]"), ylabel("E [meV]");
subplot(312), plotyy(x_p1, Psi_p1, x_p1, v_p1), title(strcat("Fonction d'onde pour d = ", num2str(dd(p1)))), xlabel("x [m]"), ylabel("Psi");
subplot(313), plotyy(x_p2, Psi_p2, x_p2, v_p2), title(strcat("Fonction d'onde pour d = ", num2str(dd(p2)))), xlabel("x [m]"), ylabel("Psi");

