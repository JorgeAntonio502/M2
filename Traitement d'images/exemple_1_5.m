clear all
close all
clc

% Taille de l'image
n = 300;
m = 600;

% Pas de teinte sur les dix niveaux
nb_teintes = 10;
d_teintes = 255/nb_teintes;
dx = int8(n/nb_teintes);

% Boucle de création du dégradé
for i = 1:n
  for j = 1:m
    if i >
    end
    B(i, j, 1) = i*d_teintes;
    B(i, j, 2) = 0;
    B(i, j, 3) = 0;
  end
end

B = uint8(B);
imshow(B);

