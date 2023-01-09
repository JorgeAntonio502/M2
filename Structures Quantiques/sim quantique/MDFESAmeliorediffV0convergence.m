%Sparse matrix et convergence cas semi analytique
clear

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charge de l'electron
hbar= 6.626e-34/2/pi;

a=10e-9; %largeur du puit quantique

E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique

% Variation logarithmique
V0=logspace(3,6,20);
v0=V0/E0; %V0 en meV puis Normalisation

Lb=5; N=1000; delt=Lb/N;
xb=-Lb/2+Lb/N*(0:N);
nmodes = 3; options.disp=0;

ee=ones(N+1,1); Lap=spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
EEn=[];
for p = 1:length(V0),
  vn=v0(p)*(abs(xb)>.5);
  A=-1/pi^2/delt^2*Lap+spdiags(vn.',0,N+1,N+1);
  [psi,En]=eigs(A,nmodes, 'sm',options);
  En=diag(En);
  EEn=[EEn,En]
end
%.' prime c'est la transposé (non conjuguée)

%plus on tends vers puit quantique infini plus le resultat de En tends vers celui de ce cas aussi

plot(v0,4,'-',v0,EEn);


%maintenant on veut tracer avec un V0 tres grand pour tracer en fct de N

