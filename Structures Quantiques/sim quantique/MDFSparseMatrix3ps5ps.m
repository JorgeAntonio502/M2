clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charge de l'electron
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

nmodes = 3; %donne la dim de psi
options.disp =0 ;

Lb=5;


NN= [100:100:3000]; logspace(2,5,50);
NN = 1000:1000:10000;

for p=1:length(NN),p,N=floor(NN(p));

  h=Lb/N;
  xb=-Lb/2+Lb/N*(0:N);
  %vn =pqrec(xb);
  vn= f(xb,6);



  %sparce matrix 3PS :
  ee=ones(N+1,1);
  Lap3= spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
  A3=-1/pi^2/h^2*Lap3+spdiags(vn.',0,N+1,N+1);
  [psi3,En3]=eigs(A3,nmodes, 'sm',options);
  EEn3(:,p)=sort(diag(En3));

  %sparce matrix 5PS :

  a0= -5/(2*h^2);
  a1=4/(3*h^2);
  a2 = -1/(12*h^2);

  Lap5= (-1/pi^2)*spdiags([a2*ee a1*ee a0*ee a1*ee a2*ee],[-2 -1 0 1 2],N+1,N+1);
  A5=-1/pi^2/h^2*Lap5+spdiags(vn.',0,N+1,N+1);
  [psi5,En5]=eigs(A5,nmodes, 'sm',options);
  EEn5(:,p)=sort(diag(En5));


end

%{
plot(NN, EEn5,'Linewidth',1)
title("");
xlabel("");
ylabel("");
hold on
%}

% Différence entre 3PS et 5PS
dE = abs(EEn3 - EEn5);

% Présentation des résultats
figure;
subplot(211);
hold on, plot(NN, EEn3, ";3PS;"), plot(NN, EEn5,";5PS;"), hold off;
title("Énergie du mode fondamental");
xlabel("N"), ylabel("E");

subplot(212), plot(NN, dE);
title("Différence des énergies du mode fondamental");
xlabel("N"), ylabel("Delta E");


