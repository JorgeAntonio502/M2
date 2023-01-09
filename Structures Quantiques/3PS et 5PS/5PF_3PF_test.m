clear

%% ---------- Approximation de derivees

N = 10000;
x = (0:N)*(2*pi/N);
h = 2*pi/N;

% La dérivée numérique va de 1 à N-1 car il faut le point suivant à chaque fois

DN = ( sin(x(2:N)) - sin(x(1:N-1)) )/h; % = (Point droite - Point gauche)/h, vecteurs décalés

% Différence entre DN et vraie dérivée
Error_1 = cos(x(1:N-1)) - DN;

% x(1:N) : x de 1 à N

subplot(4, 1, 1), plot(x, sin(x), x, cos(x), x(1:N-1), DN, 'linewidth', 2)
title("tracé DN")
xlabel("x")
legend({'sin(x)','cos(x)', 'DN'})

subplot(4, 1, 2), plot(x(1:N-1), Error_1)
title("Erreur de la DN")
xlabel("x")

%% ---------- Dérivée seconde
N = 100;
x = (0:N)*(2*pi/N);
h = 2*pi/N;

dx = x(2:N-1);

DN = (sin(dx+h) - 2*sin(dx) + sin(dx-h) )/(h^2);

subplot(4, 1, 3), plot(dx, -sin(dx), dx, DN, 'o', 'Linewidth', 2)
title("tracé DN seconde de sin(x)")
legend({'-sin(x)', 'DN seconde'})
xlabel("x")

%% ----------- Evaluation de l'erreur de 3PS et 5PS pour la DN seconde (Moindres carrés)
NN = (1:100)*10;

x0 = 5;
a = 0.1;
f = @(x) exp(-(x-x0).^2/a);
x_test = x0-10:0.1:x0+10;

for p = 1:10

	N = NN(p);
	x = (0:N)*2*pi/N;
	h = 2*pi/N;

	dx3 = x(2:N-1);
	dx5 = x(3:N-2);

	DN_3 = (f(dx3 + h) - 2*f(dx3) + f(dx3-h))/(h^2);
	Err_3(p) = sum(( -f(dx3) - DN_3 ).^2);

	DN_5 = ( -f(dx5-2*h)/12 + 4*f(dx5-h)/3 - 5*f(dx5)/2 + 4*f(dx5+h)/3 - f(dx5+2*h)/12)/(h^2);
	Err_5(p) = sum((-sin(dx5)-DN_5).^2);

end

%% ---------- Tracé dérivée analytique et approximation

fpp = @(x) -2/a * exp(-(x-x0).^2/a) + 4/a^2 * (x-x0).^2 .* exp(-(x-x0).^2/a);

subplot(4, 1, 4), plot(dx3, DN_3, x_test, fpp(x_test), 'Linewidth', 2)
title("Comparaison 3PS et dérivée seconde analytique")
legend({'3PS', 'Analytique'})
xlabel("x")
