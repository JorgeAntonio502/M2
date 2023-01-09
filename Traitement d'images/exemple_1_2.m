% Copie d'une image et sauvegarde
close all
clear all
clc

% Lecture de l'image d'origine
A = imread('andromeda.bmp');
A = double(A);

% Boucle de copie
for i = 1:size(A, 1)
  for j = 1:size(A, 2)
    B(i, j, 1) = A(i, j, 1);
    B(i, j, 2) = A(i, j, 2);
    B(i, j, 3) = A(i, j, 3);
  end
end

% Tous les pixels à 255
for i = 1:size(A, 1)
  for j = 1:size(A, 2)
    B(i, j, 1) = 255;
    B(i, j, 2) = 255;
    B(i, j, 3) = 255;
  end
end


% Reconversion des images A et B
A = uint8(A);
B = uint8(B);

% Affichage de l'image copiee
imshow(B)

% Enregistrement de la copie
imwrite(B, 'andromeda_copiee.bmp');
