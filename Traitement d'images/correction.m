clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%
% Correction et tips
%%%%%%%%%%%%%%%%%%%%

% Copie tableaux
% A = B équivalent à la double boucle (inutile de mettre les parenthèse (:,:,:)
% Noir et blanc avec une seule couche : B(:,:) = A(:,:,1)
% C(end, 1) "end" trouve la dernière ligne

% Fabrication par bloc
B(1:100, 1:200, 1) = zeros(100, 200);
B(1:100, 1:200, 2) = zeros(100, 200);
B(1:100, 1:200, 3) = 250*ones(100, 200);
imshow(B)

% Remplissage à la volée possible
for i = 1:100
  B(1, i) = 8;
end
% Possible mais attention pour les grands tableaux





