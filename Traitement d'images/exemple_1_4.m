close all
clear all
clc

%{
% Creation de mires de couleurs (drapeau Français)
% Parcours pixels selon largeur

for i = 1:300
  % Parcours pixels première bande
  for j = 1:200
    B(i, j, 1) = 0;
    B(i, j, 2) = 0;
    B(i, j, 3) = 255;
  end
  % Parcours pixels seconde bande
  for j = 201:400
    B(i, j, 1) = 255;
    B(i, j, 2) = 255;
    B(i, j, 3) = 255;
  end
  % Parcours pixels troisième bande
  for j = 401:600
    B(i, j, 1) = 255;
    B(i, j, 2) = 0;
    B(i, j, 3) = 0;
  end
end

% Creation de mires de couleurs (drapeau Papouasie)
%{
  Possible avec meshgrid : 2 tableaux
  - Un tableau A des indices de lignes
  - Un tableau B des indices de colonnes
  Test sur un tableau C créé à partir de A > B
%}

B = zeros(300, 600, 3); % Tableau "noir"

for i = 1:300
  for j = 2*i:600
    B(i, j, 1) = 255;
    B(i, j, 2) = 0;
    B(i, j, 3) = 0;
  end
end
%}

% Creation de mires de couleurs (drapeau Japon)
B = ones(300, 600, 3);
B = 255*B; % Tableau "blanc"

for i = 1:300
  for j = 1:600
    % Condition sur équation du cercle
    if ( (i-150)**2 + (j-300)**2 ) < 2000
      B(i, j, 1) = 255;
      B(i, j, 2) = 0;
      B(i, j, 3) = 0;
    end
  end
end

% Conversion en format image
B = uint8(B);

% Affichage
imshow(B);
