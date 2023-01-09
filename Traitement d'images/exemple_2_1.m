close all
clear all
clc

A = imread('andromeda.bmp');
A = double(A);
%{
  Masque créé par défaut avec Tous ses éléments nuls
  Les zones à sélectionner sont mise à 1 après

  Le masque possède 2 dimensions : celles de l'image originale
  Les dimensions des 3 canaux RGB sont absentes
%}

% Matrice Maskee de même taille que l'image
for i = 1:size(A,1)
  for j = 1:size(A,2)
    % Ignore tout par défaut
    Maskee(i,j) = 0;
  end
end

% Pixels de l'image à sélectionner mis à 1
for i = 100:170
  for j = 150:249
    % Zone à sélectionner
    Maskee(i,j) = 1;
  end
end

% Application du masque sur chacun des trois canaux R G B
% Application du masque sur canal rouge
AMaskee(:,:,1) = A(:,:,1).*Maskee;
% Application du masque sur canal vert
AMaskee(:,:,2) = A(:,:,2).*Maskee;
% Application du masque sur canal bleu
AMaskee(:,:,3) = A(:,:,3).*Maskee;

% Creation tableau monochrome
B(1:size(A, 1), 1:size(A, 2), 1:3) = 0,0,0;

A_Maskee_bis(:,:,1) = A(:,:,1).*Maskee(:,:)+B(:,:,1).*(1-Maskee(:,:));
A_Maskee_bis(:,:,2) = A(:,:,2).*Maskee(:,:)+B(:,:,2).*(1-Maskee(:,:));
A_Maskee_bis(:,:,3) = A(:,:,3).*Maskee(:,:)+B(:,:,3).*(1-Maskee(:,:));

% Conversion des masques
AMaskee = uint8(AMaskee);
AMaskee = uint8(A_Maskee_bis);

% Affichage
imshow(A_Maskee_bis)
imwrite(A_Maskee_bis, 'andromeda_maskee_bis.bmp')
