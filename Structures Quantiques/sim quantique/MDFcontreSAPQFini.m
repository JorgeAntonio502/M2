clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charche de l'electron
hbar= 6.626e-34/2/pi;
a=10e-9; %largeur du puit quantique
E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique

%vaut mieux faire un truc logarithmique
V0=1000;v0=V0/E0;

%fonction à profil lisse
VA=v0; %haut
VB=0; %floor
w=1; %la taille

f=@(x,n) VA+(VB-VA)*exp(-(2*x/w).^(2*n));

%pq rectangulaire pour comparer
pqrec = @(x) VA*(abs(x)>.5);

% Dimension de la matrice "psi" contenant les différentes fonctions d'onde pour chaque n
nmodes = 3;
options.disp =0 ;

Lb=5;

NN= [100:100:3000]; logspace(2,5,50);

for p=1:length(NN),p,N=floor(NN(p));

  delt=Lb/N;
  xb=-Lb/2+Lb/N*(0:N);
  %vn =pqrec(xb);
  vn= f(xb,6);

  %B =-2*diag(ones(N+1,1))+diag(ones(N,1),1)+diag(ones(N,1),-1);
  %A=-1/pi^2/delt^2*B+diag(vn);

  ee=ones(N+1,1); Lap=spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
  A=-1/pi^2/delt^2*Lap+spdiags(vn.',0,N+1,N+1);
  [psi,En]=eigs(A,nmodes, 'sm',options);
  EEn(:,p)=sort(diag(En));
end

plot(NN,EEn,'Linewidth',1)
title("");
xlabel("");
ylabel("");
hold on


