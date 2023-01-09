%convergencee de la MDF pour un PQ abrupte

clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charche de l'electron
hbar= 6.626e-34/2/pi;
a=10e-9; %largeur du puit quantique
E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique

%vaut mieux faire un truc logarithmique

V0= 1000 ;%meV
v0=V0/E0; %V0 en meV puis Normalisation

Lb=5;

% NN= [100:100:1e3 2000:1e3:4000];
NN= logspace(2,5,50);

for p=1:length(NN)
  p

  N=floor(NN(p));

  delt=Lb/N;
  xb=-Lb/2+Lb/N*(0:N);

  vn=v0*(abs(xb)>.5);

  nmodes = 2; %donne la dim de psi
  options.disp =0 ;

  %B =-2*diag(ones(N+1,1))+diag(ones(N,1),1)+diag(ones(N,1),-1);
  %A=-1/pi^2/delt^2*B+diag(vn);


  ee=ones(N+1,1); Lap=spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
  A=-1/pi^2/delt^2*Lap+spdiags(vn.',0,N+1,N+1);
  [psi,En]=eigs(A,nmodes, 'sm',options);
  EEn(:,p)=E0*sort(diag(En));
end

%vrai valeur trouvé avec SA
E1SA =42.298056780211112;
E2SA = 168.1689175719088;


Evrai = [E1SA;E2SA];
Evrai = repmat(Evrai,1,length(NN));

subplot(211), loglog(NN,abs(EEn-Evrai),'Linewidth',1);
title("Comparaison de la MSA et la MDF - échelles logarithmiques");

subplot(212),semilogx(NN,abs(EEn-Evrai),'Linewidth',1);
title("Comparaison de la MSA et la MDF - semilogx");



%maintenant on veut tracer avec un V0 tres grand pour tracer en fct de N
%.' prime c'est la transposé (non conjugué)

%plus on tends vers puit quantique infini plus le resultat de En tends vers celui de ce cas aussi

