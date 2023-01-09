clear

% Paramètres physiques
a = 1e-09;
m_e = 9.1091e-31;
m_eff = 0.067 * m_e;
q_e = 1.602176565e-19;
h_bar = 6.626e-34 / 2 / pi;
E_0 = h_bar^2 * pi^2 / (2 * m_eff * a^2) / q_e * 1.e03;
V_0 = 400;
v_0 = V_0 / E_0;


% Paramètres de la simulation
l_bar = 15;
N = 6000;
n_modes = 5;

% Initialisation des tableaux
aa_bar = linspace(1, 10, 100);
EE_bar = [];


for p = 1:length(aa_bar)
  EE_bar(:, p) = energy_rect(v_0, aa_bar(p), N, l_bar, n_modes);
end

% Dénormalisations
aa = aa_bar * a;
EE = EE_bar * E_0;
EE(EE > V_0) = nan;

% Présentation des résultats
figure;
plot(aa, EE), title("Énergies des trois premiers modes en fonction de a"), xlabel("a [m]"), ylabel("E [meV]");


