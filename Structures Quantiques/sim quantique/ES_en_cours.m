clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charche de l'electron
hbar= 6.626e-34/2/pi;

a=10e-9; %largeur du puit quantique

E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique
V0=1000;v0=V0/E0; %V0 en meV puis Normalisation

Lb=5; N=1000; delt=Lb/N;
xb=-Lb/2+Lb/N*(0:N);
vn=v0*(abs(xb)>.5);

nmodes = 7 ; %permet de changer facilement le nombre de mode dans egg
%matrice diagonale diag(ones(N+1,1)) cr
B =-2*diag(ones(N+1,1))+diag(ones(N,1),1)+diag(ones(N,1),-1);
A=-1/pi^2/delt^2*B+diag(vn);
[psi,En]=eigs(A,nmodes, 'sm'); %sort les vecteur propres psi; valeurs propres E0
% sm permet de choisir du smolest modulus

En=E0*diag(En); %passe d'une matrice a un vecteur, et *E0 pour dénormaliser

plot(v0,En)

%figure;
subplot(321); plot(xb,psi(:,7)); %toute les lignes 7ième colonne
subplot(322); plot(xb,psi(:,6));
subplot(323); plot(xb,psi(:,5));
subplot(324); plot(xb,psi(:,4));
subplot(325); plot(xb,psi(:,3));
subplot(326); plot(xb,psi(:,2));

%il y a seulement 5modes car le 6 déborde
%pour le confirmer on voit les En si certaines sont >V0  ici 1000 alors l'electron sort du confinement
