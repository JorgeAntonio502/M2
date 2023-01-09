%fonction à profil lisse
n=2
VA=1; %haut
VB=0; %floor
w=1; %la taille

% Fonction du potentiel lisse
f=@(x,n) VA+(VB-VA)*exp(-(2*x/w).^(2*n));

% Abscisses
x=linspace(-3,3,1e3);

% Tracer juste un n
%plot(x,f(x,n), 'Linewidth',1)

% Tracer plusieurs n
figure; hold on
for n=1:5,
  plot(x,f(x,n),'Linewidth',1)
 end
