clear

% Constantes du problème
alphan = 1
lambda = 1
k_0 = 2*pi/lambda
R = 2
r = 1
mu_r = 1
eps_r = 2
Z_r = sqrt(eps_r/mu_r)

%ordre maximal calculé à chaque itération
N = 50
S = 1 : N % tableau pour contenir les N ordres calculés 
S_max = 0; % Variable contenat le max de S
ordre_max = 0;
seuil = 100

% Nombre de points à calculer
nb_iterations = 100
A = linspace(1, 50, nb_iterations) % facteur pour chaque itération
Ordre = zeros(1, nb_iterations) % tableau contenant l'ordre d'effondrement pour chaque valeurs du ratio 


% Début des itérations
for i = 1 : nb_iterations

	S_max = 0
	ordre_max = 0
	
	R = A(i) * lambda % R déduit du ratio pour ce tour
	
	for n  = 0 : N % Remplissage de S avec les N ordres de dn calculés
		S(n+1) = abs(alphan * ((dbesselh(n, k_0*R) .* besselj(n, k_0*r) - besselh(n, 1, k_0*R) .* dbesselj(n, k_0*r)) ./ (dbesselh(n, k_0*R) .* besselj(n, k_0*mu_r*R) - Z_r*besselh(n, 1, k_0*R) .* dbesselj(n, k_0*mu_r*R) )));
		
		if S(n+1) > S_max
			S_max = S(n+1) % Valeur du max de S
			ordre_max = n+1
		end
		
	end
	
	for j = ordre_max : N % Parcours des valeurs de S calculées précédemment
		S(j)
		if S(j)*seuil < S_max % Si la valeur de l'ordre j est seuil fois plus petite que la valeur max de S
			Ordre(i) = j	% On note l'ordre d'effonfrement dans Ordre
			break		% On casse la boucle
		end
	
	end
end

A
Ordre

plot(A, Ordre)
pause
