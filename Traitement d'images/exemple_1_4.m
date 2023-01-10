close all
clear all
clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creation de mires de couleurs (drapeau Français)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% Affichage
subplot(311), imshow(B);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creation drapeau Papouasie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
  Possible avec meshgrid : 2 tableaux
  - Un tableau A des indices de lignes
  - Un tableau B des indices de colonnes
  Test sur un tableau C créé à partir de A > B
%}

B = zeros(300, 600, 3); % Tableau "noir"

a = size(B, 1)/size(B, 2); % Coefficient directeur diagonale

for i = 1:300
  for j = 1:600
    if i < a*j
      B(i, j, 1) = 255;
      B(i, j, 2) = 0;
      B(i, j, 3) = 0;
    end
  end
end

% Affichage
subplot(312), imshow(B);

%%%%%%%%%%%%%%%%%%%%%%%%
% Creation drapeau Japon
%%%%%%%%%%%%%%%%%%%%%%%%
B = 210*ones(300, 600, 3); % Tableau "blanc"

for i = 1:300
  for j = 1:600
    % Condition sur équation du cercle
    if ( (i-150).^2 + (j-300).^2 ) < 2000
      B(i, j, 1) = 255;
      B(i, j, 2) = 0;
      B(i, j, 3) = 0;
    end
  end
end

% Affichage
B = uint8(B);
subplot(313), imshow(B);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Technique avec meshgrid()
%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%%%%%%%%%%%%%%%%
% Drapeau France
%%%%%%%%%%%%%%%%

% Utiliser la fabrication par bloc de préference
France = ones(200, 300, 3);

France(:, 1:100, 1) = zeros(200, 100);
France(:, 1:100, 2) = zeros(200, 100);
France(:, 1:100, 3) = 255*ones(200, 100);

France(:, 101:200, 1) = 255*ones(200, 100);
France(:, 101:200, 2) = 255*ones(200, 100);
France(:, 101:200, 3) = 255*ones(200, 100);

France(:, 201:300, 1) = 255*ones(200, 100);
France(:, 201:300, 2) = zeros(200, 100);
France(:, 201:300, 3) = zeros(200, 100);

France = uint8(France);
subplot(311), imshow(France)

%%%%%%%%%%%%%%%%%%%
% Drapeau Papouasie
%%%%%%%%%%%%%%%%%%%

[x, y] = meshgrid(1:300, 1:200); % image 200*300
% x contient les numéros de colonnes
% y contient les numéros de lignes

% Drapeau rouge par défaut
B(1 : 200, 1:300, 1) = 255;
B(1 : 200, 1:300, 2:3) = 0;

mask = x > (300/200)*y; % Ne contient que des 0 et des 1

B(:,:,1) = B(:,:,1).*mask;
% B(:,:,2) = B(:,:,2).*mask;
% B(:,:,3) = B(:,:,3).*mask;

B = uint8(B);
subplot(312), imshow(B)

%%%%%%%%%%%%%%%
% Drapeau Japon
%%%%%%%%%%%%%%%

[x, y] = meshgrid(1:300, 1:200); % image 200*300
% x contient les numéros de colonnes
% y contient les numéros de lignes

B1(1 : 200, 1:300, 1) = 255; % drapeau rouge
B1(1 : 200, 1:300, 2:3) = 0;

B2(1 : 200, 1:300, 1:3) = 210; % drapeau blanc

mask = (x-150).^2 + (y-100).^2 < 1000;

Japon(:,:,:) = B1.*mask + B2.*(1-mask);
% B(:,:,2) = B(:,:,2).*mask;
% B(:,:,3) = B(:,:,3).*mask;

Japon = uint8(Japon);
subplot(313), imshow(Japon)
