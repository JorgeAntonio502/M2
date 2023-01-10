close all
clear all

A = imread('andromeda.bmp');
A = double(A);

% Copie de A dans B
B(1:size(A, 1), 1:size(A, 2), 1:3) = A(1:size(A, 1), 1:size(A, 2), 1:3);

% Modifications sur la copie B : ajout carré blanc
B(10:20, 10:20, 1:3) = 255;

% Ajout carré de pixels (70, 100, 125) à partir de 50*50
B(50:100, 50:100, 1) = 70;
B(50:100, 50:100, 2) = 100;
B(50:100, 50:100, 3) = 125;

% Même carré en rouge
B(50:100, 50:100, 1) = 255;
B(50:100, 50:100, 2) = 0;
B(50:100, 50:100, 3) = 0;

% Affichage
A = uint8(A);
B = uint8(B);

%{
% Canal rouge
subplot(311), imshow(B(:, :, 1))
% Canal vert
subplot(312), imshow(B(:, :, 2))
% Canal bleu
subplot(313), imshow(B(:, :, 3))
%}

% Canal rouge dans canal vert et vert dans rouge
% Copie canal vert de A dans C temporaire
C = A(:,:,2);
% Copie canal rouge de A dans canal vert de A
A(:,:,2) = A(:,:,1);
% Copie canal vert de C dans canal rouge de A
A(:,:,1) = C;

% Permutation circulaire

imshow(A)






