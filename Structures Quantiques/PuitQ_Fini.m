% ---- Puits fini : semi-analytique ----
clear;

% Constantes du proclème
me = 9.1091e-31; meff = 0.067*me; e = 1.602176565e-19; hbar = 6.626e-34/2/pi;
a = 10e-9;
E0 = hbar^2*pi^2/(2*meff*a^2)/e*1e3;
V0 = 1000; Vb = V0/E0;
q0 = pi*sqrt(Vb);

% Déclaration fonctions
f = @(x) abs(cos(x/2)).*(tan(x/2) > 0); ff = @(x) f(x) - x/q0;
g = @(x) abs(sin(x/2)).*(tan(x/2) < 0); gg = @(x) g(x) - x/q0;

x = linspace(0, 50, 1000);
subplot(4, 1, 1), plot(x, f(x), x, x/q0) % subplot(nombre de plots, nombre de lignes, numéro de plot)
subplot(4, 1, 2), plot(x, g(x), x, x/q0)

% Création des seeds
seed1 = [3.1 9 15] ; qmod1 = fsolve(ff, seed1); Emod1b = qmod1.^2/pi^2;
Emod1 = Emod1b*E0;
seed2 = [5 11] ; qmod2 = fsolve(gg, seed2); Emod2b = qmod2.^2/pi^2; 
Emod2 = Emod2b*E0;

%return

% ----Tracé modes pairs 

L = 5; Nx = 1000; xb = linspace(-L/2, L/2, Nx); qn = qmod1(1); kn = sqrt(pi^2*Vb-qn^2);
Ac = 1; Ag = 2*Ac*exp(kn/2) * cos(qn/2); Bd = Ag;

psi = (xb <= -0.5).*(Ag*exp(kn*xb)) +...
	(xb > -0.5 & xb <= 0.5).*(2*Ac*cos(qn*xb)) +...
	(xb >= 0.5).*(Bd*exp(-kn*xb));
	
subplot (4, 1, 3), plot(xb, psi);

% ----Tracé modes impairs

L = 2; Nx = 1000; xb = linspace(-L/2, L/2, Nx); qn = qmod2(2); kn = sqrt(pi^2*Vb-qn^2);
Ac = -i; Ag = -2*i*Ac*exp(kn/2)*sin(qn/2); Bd = -Ag;

psi = (xb <= -0.5).*(Ag*exp(kn*xb)) +...
	(xb > -0.5 & xb <= 0.5).*(2*i*Ac*sin(qn*xb)) +...
	(xb >= 0.5).*(Bd*exp(-kn*xb));

subplot (4, 1, 4), plot(xb, psi);
return
