close all
clear all
clc

%{
  Masque créé par défaut avec Tous ses éléments nuls
  Les zones à sélectionner sont mise à 1 après

  Le masque possède 2 dimensions : celles de l'image originale
  Les dimensions des 3 canaux RGB sont absentes
%}

%{
% Lecture image
A = imread('andromeda.bmp');
% A = double(A);


%%%%%%%%%%%%%%%%
% Premier masque
%%%%%%%%%%%%%%%%


% Matrice Maskee de 0 de même taille que l'image
for i = 1:size(A,1)
  for j = 1:size(A,2)
    % Ignore tout par défaut
    Maskee(i,j) = 0;
  end
end

% Pixels de l'image à sélectionner mis à 1 dans le masque
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

% Affichage avec premier masque
subplot(211), imshow(AMaskee)
% imwrite(A_Maskee_bis, 'andromeda_maskee.bmp');



%%%%%%%%%%%%%%%%
% Second masque
%%%%%%%%%%%%%%%%



% Creation tableau monochrome
% B(1:size(A, 1), 1:size(A, 2), 1:3) = A(1:size(A, 1), 1:size(A, 2), 1:3);

for i = 1:size(A,1)
  for j = 1:size(A,2)
    B(i, j, 1) = 0;
    B(i, j, 2) = 0;
    B(i, j, 3) = 0;
  end
end

A_Maskee_bis(:,:,1) = A(:,:,1).*Maskee(:,:)+B(:,:,1).*(1-Maskee(:,:));
A_Maskee_bis(:,:,2) = A(:,:,2).*Maskee(:,:)+B(:,:,2).*(1-Maskee(:,:));
A_Maskee_bis(:,:,3) = A(:,:,3).*Maskee(:,:)+B(:,:,3).*(1-Maskee(:,:));

% Affichage avec second masque
subplot(212), imshow(A_Maskee_bis);
% imwrite(A_Maskee_bis, 'andromeda_maskee_bis.bmp');

%}


%%%%%%%%%%%%%%%%%%%%
% Signa : Exercice 1
%%%%%%%%%%%%%%%%%%%%

% Lecture images
A = imread('Signac_1.bmp');
B = imread('Signac_2.bmp');

% Masque pour A et B
for i = 1:size(A,1)
  for j = 1:size(A,2)
    % Ignore tout par défaut
    Mask(i,j) = 0;
  end
end

% Traitement des masques

a = size(A,1)/size(A,2); % coefficient directeur de la diagonale

for i = 1:size(A,1)
  for j = 1:size(A,2)
    if i > a*j
      % Accepter ce qui est au dessus de la diagonale
      Mask(i,j) = 1;
    end
  end
end

% Application du masque sur chacun des trois canaux R G B
% Application du masque sur canal rouge
AMaskee(:,:,1) = A(:,:,1).*Mask + B(:,:,1).*~Mask;
% Application du masque sur canal vert
AMaskee(:,:,2) = A(:,:,2).*Mask + B(:,:,2).*~Mask;
% Application du masque sur canal bleu
AMaskee(:,:,3) = A(:,:,3).*Mask + B(:,:,3).*~Mask;

% Affichage
subplot(311), imshow(AMaskee)


%%%%%%%%%%%%%%%%%%%%
% Signa : Exercice 2
%%%%%%%%%%%%%%%%%%%%

% masque initial
Mask = zeros(size(A, 1), size(A, 2));

% Creation masque circulaire
x0 = size(A,1)/2; % Coordonnée x centre image
y0 = size(A,2)/2; % Coordonnée y centre image
R = 5000; % Rayon du cercle

for i = 1:size(A,1)
  for j = 1:size(A,2)
    % Condition sur équation cercle au centre de l'image
    if (i-x0)**2 + (j-y0)**2 < R
      Mask(i,j) = 1;
    end
  end
end

% Application du masque sur chacun des trois canaux R G B
% Application du masque sur canal rouge
AMaskee(:,:,1) = A(:,:,1).*Mask;
% Application du masque sur canal vert
AMaskee(:,:,2) = A(:,:,2).*Mask;
% Application du masque sur canal bleu
AMaskee(:,:,3) = A(:,:,3).*Mask;

% Affichage
subplot(312), imshow(AMaskee)



%%%%%%%%%%%%%%%%%%%%%%%%%
% Combinaisons de masques
%%%%%%%%%%%%%%%%%%%%%%%%%



% Image monochrome
A = ones(200, 200, 3);

% Masque diagonal
M1 = spdiags([ones(size(A, 1),1) ones(size(A, 1),1) ones(size(A, 1),1)], [50 56 57], size(A, 1), size(A, 2));
% Masque triangulaire
M2 = zeros(size(A, 1), size(A, 2));
a = size(A,1)/size(A,2);
for i = 1:size(A,1)
  for j = 1:size(A,2)
    if i > a*j
      M2(i,j) = 1;
    end
  end
end
% Masque circulaire
M3 = zeros(size(A, 1), size(A, 2));
x0 = size(A,1)/2;
y0 = size(A,2)/2;
R = 500;
for i = 1:size(A,1)
  for j = 1:size(A,2)
    if (i-x0)**2 + (j-y0)**2 < R
      M3(i,j) = 1;
    end
  end
end

% Application des masques sur chacun des trois canaux R G B
A(:,:,1) = A(:,:,1).*(M1 + M2 + M3);% + A(:,:,1).*M2 + A(:,:,1).*M3;
A(:,:,2) = A(:,:,2).*(M1 + M2 + M3);% + A(:,:,2).*M2 + A(:,:,2).*M3;
A(:,:,3) = A(:,:,3).*(M1 + M2 + M3);% + A(:,:,3).*M2 + A(:,:,3).*M3;

% Affichage
subplot(313), imshow(A)

