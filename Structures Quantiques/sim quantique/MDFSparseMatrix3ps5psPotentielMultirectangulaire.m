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

%pqrec = @(x) VA*(abs(x)>.5);
pqm = @(x)v0*(abs(x)>.5)+v0/2*(x>=0 & x<.5);


Lb=5; N=1e5; delta=Lb/N; xb=-Lb/2+Lb/N*(0:N);

%profil
  %vn =pqrec(xb);
  %vn= f(xb,6);
  vn=pqm(xb);



NN= [100:100:3000]; logspace(2,5,50);

am2=-1/12/delta^2;ap2=am2; am1=4/3/delta^2; ap1=am1; a0=-5/2/delta^2;

nmodes = 3; options.disp =0 ;

  %sparce matrix 3PS :
  ee=ones(N+1,1); Lap3= spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
  A3=-1/pi^2/delta^2*Lap3+spdiags(vn.',0,N+1,N+1);

  ee = ones(N+1,1); Lap =spdiags([am2*ee am1*ee a0*ee am1*ee am2*ee],[-2 -1 0 1 2],N+1,N+1); A=-1/pi^2*Lap+spdiags(vn.',0,N+1,N+1);

  [psi3,En3]=eigs(A,nmodes, 'sm',options);
  EEn3=sort(diag(En3));

  pp=2;

plot(xb,(.5*(1-psi(:,pp)/(max(abs(psi(:,pp)))))),'Linewidth',1)
title("");
xlabel("");
ylabel("");
hold on


