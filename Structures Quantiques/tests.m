% Déclaration fonction à plusieurs variables (vectorielle)
f = @(x, y) log(3*x.^2 + y.^2 + 1);

% Intervales selon x et y
[x, y] = meshgrid(-7:0.2:7, -7:0.5:7);

% Affichage en 2D
pcolor(x, y, f(x, y))

% Noms axes et titre
xlabel("x")
ylabel("y") 
title("ln(3x^2 + y^2 + 1)")

% Options affichage
axis equal tight
shading flat

% Affichage en 3D
surf(x, y, f(x,y))
xlabel("x")
ylabel("y") 
zlabel("ln(3x^2 + y^2 + 1)")

return

% Résolution de système 

% Constantes
me = 9.1091e-31; meff = 0.067*me; e = 1.602176565e-19; hbar = 6.626e-34/2/pi;
a = 10e-9;
E0 = hbar^2*pi^2/(2*meff*a^2)/e*1e3;
V0 = 1000; Vb = V0/E0;
q0 = pi*sqrt(Vb);

% Déclaration fonctions
f = @(x) abs(cos(x/2)).*(tan(x/2) > 0); ff = @(x) f(x) - x/q0;
g = @(x) abs(sin(x/2)).*(cot(x/2) < 0); gg = @(x) g(x) - x/q0;

x = linspace(0, 50, 1000);

% Affichage
% subplot(nombre de plots, nombre de lignes, numéro de plot)
subplot(2, 1, 1), plot(x, f(x), x, x/q0)
xlabel("k/2")
ylabel("|cos(k/2)| && tan(k/2) > 0") 
subplot(2, 1, 2), plot(x, g(x), x, x/q0)
xlabel("k/2")
ylabel("|sin(k/2)| && cotan(k/2) < 0") 

% Création des seeds
seed1 = [3.1] ; % Si plusieurs valeurs, alors donne le 0 le plus proche pour chacune  
qmod1 = fsolve(ff, seed1)
Emod1b = qmod1.^2/pi^2;
Emod1 = Emod1b*E0;

seed2 = [5 11] ; 
qmod2 = fsolve(gg, seed2)
Emod2b = qmod2.^2/pi^2; 
Emod2 = Emod2b*E0;
