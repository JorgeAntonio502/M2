clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charche de l'electron
hbar= 6.626e-34/2/pi;
a=10e-9; %largeur du puit quantique
E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique

V0= 10e12 ;%meV
v0=V0/E0; %V0 en meV puis Normalisation

Lb=10;

% Variation linéaire
% NN= [100:100:1e3 2000:1e3:4000];

% Variation logarithmique
NN= logspace(2,5,50);

for p = 1:length(NN), p, N=floor(NN(p));

  delt=Lb/N;
  xb=-Lb/2+Lb/N*(0:N);

  vn=v0*(abs(xb)>.5);

  nmodes = 3;
  options.disp=0;
  EEn=[];

  %B =-2*diag(ones(N+1,1))+diag(ones(N,1),1)+diag(ones(N,1),-1);
  %A=-1/pi^2/delt^2*B+diag(vn);

  ee=ones(N+1,1); Lap=spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
  A=-1/pi^2/delt^2*Lap+spdiags(vn',0,N+1,N+1);
  [psi,En]=eigs(A,nmodes, 'sm',options);
  En=diag(En);
  EEn(:,p)=En;
end

% Valeurs de référence
% E1SA = 42.2 meV
% E2SA = 168.1 meV

% Affichage
plot(NN,EEn);


%maintenant on veut tracer avec un V0 tres grand pour tracer en fct de N
%.' prime c'est la transposé (non conjugué)

%plus on tends vers puit quantique infini plus le resultat de En tends vers celui de ce cas aussi

