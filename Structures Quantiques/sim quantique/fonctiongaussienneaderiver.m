clear

#paramètres
N=1000;
x0=5;
L=10;
a=0.1;

h=L/N;

% Domaine de définition (Df) de la fonction à dériver
x=(0:N)*h;
% Le Df de la dérivée numérique ne contient pas les points extrêmes du Df de f(x)
dx = x(2:N-1);

# Fonction à dériver
f=@(x) exp((-((x-x0).^2))/a);

# Dérivée première numérique (centrée)
DN1 = (f(dx+h) - f(dx-h))/h;

# Dérivé 2nd Numérique à 3 points
DN2 = (f(dx+h) - 2*f(dx) + f(dx-h))/(h^2);

# Comparer avec dérivé 1ere analytique j(x)
DA1= @(x) -2.*(x-x0)/a.*exp((-((x-x0).^2))/a);

# Comparer avec dérivé seconde analytique g(x)
DA2= @(x) (-2/a).*f(x)+(4/a^2)*(x-x0).^2.*f(x);

# Tracé des dérivées premières numérique et analytiques
plot(x, f(x), dx, DN1, x, DA1(x));
legend('f(x)','DN1', 'DA1')

# Tracé des dérivées secondes numérique et analytiques
plot(dx, DN2, x, DA2(x));
legend('DN2', 'DA2')

# On fait la difference
EcartDN = DA2(dx) - DN2; % dx car sinon vecteurs de tailles invalides pour soustraction
plot(dx, EcartDN);
legend('DA2 - DN2')
