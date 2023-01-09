close all
clear all
clc

A = imread('andromeda.bmp');

% Indication pour considérer les éléments de A comme des réels
A = double(A);

% Affiche nbPixelshauteur * nbPixelslargeur * 3 (Images toujours en 3D : R G B)
size(A)
% Un à un
size(A, 1)
size(A, 2)
size(A, 3)

% Modifications de valeurs puis stockage de l'image modfifiée
A(100 ,100 ,1) = 0;
A(100 ,100 ,2) = 0;
A(100 ,100 ,3) = 0;

A = uint8(A); % Reconvertion en uint8
imwrite(A, 'andromeda-modifiee.bmp')
A = double(A); % Reconversion en réel

% Indication pour reconvertir en uint8 avant d'afficher
A = uint8(A);

% Affichage de l'image
imshow(A)

