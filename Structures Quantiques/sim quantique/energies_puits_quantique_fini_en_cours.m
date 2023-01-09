
clear
%code semi analytique
me= 9.1091e-31; %masse de l'electron
meff=0.067*me;
e= 1.602176565e-19; %charche de l'electron
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
%subplot pour ecrire plusieurs parties

seed1=[3.1 9 15 21 25];
seed1=[2.72 8.1 15];
qmod1= fsolve(ff,seed1); Emod1b=qmod1.^2/pi^2;
%on dénormalise
Emod1=Emod1b*E0;

seed2=[5 11 19 25 30];
seed2= [5.43 11];
qmod2=fsolve(gg,seed2); Emod2b = qmod2.^2/pi^2;
Emod2 = Emod2b*E0;
%si on a un vecteur avec plusieurs seed on aura pls reponses

% donner les modes Emdod1'
return
%permet d'arreter les codes

%%tracé de la fonction d'onde : modes des fonctions pairs
L=5; Nx=1000; xb=linspace(-L/2,L/2,Nx); qn=qmod1(1); kn=sqrt(pi^2*Vb-qn^2);
Ac=1;
Ag=2*Ac*exp(kn/2)*cos(qn/2); Bd=Ag;

psi= (xb<=-.5).*(Ag*exp(kn*xb))+...
      (xb>.5 & xb<=.5).*(2*Ac*cos(qn*xb))+...
      (xb>=.5).*(Bd*exp(-kn*xb));

plot(xb,psi)
return
%%tracé de la fonction d'onde : modes des fonctions impairs
L=5; Nx=1000; xb=linspace(-L/2,L/2,Nx); qn=qmod2(1); kn=sqrt(pi^2*Vb-qn^2);
Ac=-1i;
Ag=-2i*Ac*exp(kn/2)*sin(qn/2); Bd=-Ag;

psi= (xb<=-.5).*(Ag*exp(kn*xb))+...
      (xb>-.5 & xb<=.5).*(2i*Ac*sin(qn*xb))+...
      (xb>=.5).*(Bd*exp(-kn*xb));

plot(xb,psi)

return
%%
psi=@(x,alp,bet,fact) fact*exp(bet*x).*(x<-.5)+(cos(alp*x)).*(x<.5& x>-.5 & x>-.5) + fact *(exp

x=linspace(0,1.5*alp0,1e3); Plot(x,f(x),x,x/alp0, 'k',x,g(x),'r--');

hold on

%return

figure;
xb=linspace(-2,2,1e3);

seed=[2 8 13]; %subplot(211);
hold on,
for pp=1:length(seed), alps(pp) = fzero(ff,seed(pp)); bets(pp)=sqrt(alp0^2-alps(pp)^2)
  fact=exp(bets(pp)/é)*cos(alps(pp)/2);
  psii(:,pp)=psi(xb,alps(pp),bets(pp),fact);
  plot(xb,psii(:,pp)/max(abs(psii(:,pp)))+2*(pp-1))
end
return
