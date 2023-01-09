%convergenc matrix et convergence en fonction du parametre de géometrie n de la MDF pour un PQ à profil lisse

clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charche de l'electron
hbar= 6.626e-34/2/pi;
a=10e-9; %largeur du puit quantique
E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique

%vaut mieux faire un truc logarithmique
V0=1000;v0=V0/E0;

% Paramètres du potentiel
VA=v0; %haut
VB=0; %floor
w=1; %la taille

% Potentiel à profil lisse
f=@(x,n) VA+(VB-VA)*exp(-(2*x/w).^(2*n));

%pq rectangulaire pour comparer
pqrec = @(x) VA*(abs(x)>.5);

% Dimension de la matrice "psi" contenant les différentes fonctions d'onde pour chaque n
nmodes = 3;
options.disp =0 ;

% Nombre de points
N=3000
Lb=5;

% Le pas d'espace et le vecteur avec les N positions
delt=Lb/N;
xb=-Lb/2+Lb/N*(0:N);

nmax=50;

for n=1:nmax,

  %vn =pqrec(xb);
  vn= f(xb,n);
  ee=ones(N+1,1); Lap=spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);

  A=-1/pi^2/delt^2*Lap+spdiags(vn.',0,N+1,N+1);

  [psi,En]=eigs(A,nmodes, 'sm',options);
  EEn(:,n)=E0*sort(diag(En));
end
plot(1:nmax,EEn, 'Linewidth',1)




