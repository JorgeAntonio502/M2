clear all

% Constantes du problème
alphan = 1
lambda = 1
k_0 = 2*pi/lambda
R = 2

mu_r = 1
eps_r = 2
Z_r = sqrt(eps_r/mu_r)

%ordre maximal calculé à chaque itération
N = 50
S = 1 : N % tableau pour contenir les N ordres calculés 
S_max = 0; % Variable contenant le max de S
ordre_max = 0; % Variable pour contenir l'ordre du max de S
seuil = 50;

% Nombre de points à calculer
nb_iterations = 10
ratio = R/lambda
A = linspace(ratio, 2*ratio, nb_iterations) % facteur A tel que A = R/r pour chaque itération
Ordre = zeros(1, nb_iterations) % tableau contenant l'ordre d'effondrement pour chaque valeurs du ratio 


% Début des itérations
for i = 1 : nb_iterations

	S_max = 0; % Mise à zéro du max de S
	ordre_max = 0; % Mise à zéro de l'ordre du max de S
	
	R = A(i) * lambda % R déduit du ratio pour ce tour
	
	for n  = 0 : N % Remplissage de S avec les N ordres de dn calculés
		S(n+1) = abs(alphan * ((dbesselh(n, k_0*R) .* besselj(n, k_0*R) - besselh(n, 1, k_0*R) .* dbesselj(n, k_0*R)) ./ (dbesselh(n, k_0*R) .* besselj(n, k_0*Z_r*R) - Z_r*besselh(n, 1, k_0*R) .* dbesselj(n, k_0*Z_r*R) )));
		
		if S(n+1) > S_max
			S_max = S(n+1) % Valeur du max de S
			ordre_max = n+1
		end
		
	end
	
	for j = ordre_max : N % Parcours des valeurs de S à partir du max
	
		if S(j)*seuil < S_max % Si la valeur de l'ordre j est seuil fois plus petite que la valeur max de S
			Ordre(i) = j	% On note l'ordre d'effonfrement dans Ordre
			break		% On casse la boucle
		end
	
	end
end

plot(A, Ordre)
pause
