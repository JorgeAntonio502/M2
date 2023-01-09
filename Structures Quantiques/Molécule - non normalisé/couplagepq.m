clear;

% Distance entre les puits
dd = linspace(.1, 20, 100)*1e-9;

% Paramètres des puits
a = 5e-9;
V0 = 400;
N = 1e4;
Lb = 15;
nmodes = 4;

for p = 1:length(dd)

  % Distance inter-puits pour ce tour
  d = dd(p);

  % Energie d'interaction entre les puits
	EEn(:,p) = PQRECT2(V0,a,d,N,Lb,nmodes);

end

% Exlusion des énergies sans sens physique
EEn(EEn > V0) = nan;

% Affichage
plot(dd*1e9, EEn,'Linewidth', 2);
