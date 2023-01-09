
#paramètres
N=1000;
x0=5;
L=10;
a=0.1;

h=L/N;

NN=(1:100)*10;

#fonction à dériver
f=@(x) exp((-((x-x0).^2))/a);

for p=1:100,
  N=NN(p);
  x=(0:N)*h;
  dx = x(2:N-1);

  dx5PS= x(3:N-2);
  h=L/N;

  a0=(-5)/(2*h^2);
  a1 = 4/(3*h^2);



  #dérivé 2nd Numérique à 3 points
    DN2 =(f(dx+h)-2*f(dx)+f(dx-h))/(h^2);

    DN5 =(-1/(12*h^2))*f(dx5PS+2*h)+a1*f(dx5PS-h)+a0*f(dx5PS)+a1*f(dx5PS+h)+(-1/(12*h^2))*f(dx5PS-2*h);

  # comparer avec dérivé 1ere analytique j(x)
  # j= @(x) -2.*(x-x0)/a.*exp((-((x-x0).^2))/a);

  # comparer avec dérivé seconde analytique g(x)
  d2a= @(x) (-2/a).*f(x)+(4/a^2)*(x-x0).^2.*f(x);

  # on fait la difference
  Err3(p) = sum((d2a(dx)-DN2).^2);
  Err5(p) = sum((d2a(dx5PS)-DN5).^2);
end

plot(NN, Err3,NN,Err5)



