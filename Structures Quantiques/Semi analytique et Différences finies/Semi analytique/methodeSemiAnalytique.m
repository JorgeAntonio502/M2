clear
%methode semi analytique

me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charge de l'electron
hbar= 6.626e-34/2/pi;

a=10e-9; %largeur du puit quantique

E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3; %mode fondamental du puit quantique

V0 =1000; Vb = V0/E0; %on normalise
q0=pi*sqrt(Vb);

f=@(x) abs(cos(x/2)).*(tan(x/2)>0); ff=@(x) f(x)-x/q0;
g=@(x) abs(sin(x/2)).*(tan(x/2)<0); gg=@(x) g(x)-x/q0;

x=linspace(0,50,1000);

subplot(211), plot(x,f(x),x,x/q0);
subplot(212), plot(x,g(x),x,x/q0);

format long

seed1=[2];
qmod1= fsolve(ff,seed1); Emod1b=qmod1.^2/pi^2;
%on dénormalise
E1SA=Emod1b*E0

seed2=[5];
qmod2= fsolve(gg,seed2); Emod2b=qmod2.^2/pi^2;
%on dénormalise
E2SA=Emod2b*E0

%E1SA = 42.2 meV
%E2SA = 168.1 meV
