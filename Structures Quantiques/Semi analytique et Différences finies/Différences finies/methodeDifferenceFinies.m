clear
%methode des Differences finies

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

nmodes = 7; options.disp=0;
ee=ones(N+1,1); Lap=spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);


  B =-2*diag(ones(N+1,1))+diag(ones(N,1),1)+diag(ones(N,1),-1);
  A=-1/pi^2/delt^2*B+diag(vn);


  [psi,En]=eigs(A,nmodes, 'sm');

  En=E0*diag(En);
figure;
subplot(321); plot(xb,psi(:,7)); %toute les lignes 7ième colonne
subplot(322); plot(xb,psi(:,6));
subplot(323); plot(xb,psi(:,5));
subplot(324); plot(xb,psi(:,4));
subplot(325); plot(xb,psi(:,3));
subplot(326); plot(xb,psi(:,2));
