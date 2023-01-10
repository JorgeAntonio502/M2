clear all
close all
clc

% Dégradé de gris
for i = 1:200
  for k = 1:10
    for j = 50*(k-1)+1:k*50
      B(i,j) = uint8((k-1)/9*250.0);
    end
  end
end

subplot(211), imshow(B)

% dégradé de rouge
for i = 1:200
  for k = 1:10
    for j = 50*(k-1)+1:k*50
      B(i,j, 1) = 255;
      B(i,j, 2) = uint8((k-1)/9*255.0);
      B(i,j, 3) = uint8((k-1)/9*255.0);
    end
  end
end

subplot(212), imshow(B)


