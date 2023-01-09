%fonction puit quantique rectangulaire

function En = PQR(a,V0,Lb,N,nmod)
  %calcul
  me= 9.1091e-31;  meff=0.067*me;  e= 1.602176565e-19;   hbar= 6.626e-34/2/pi;
  E0=hbar^2*pi^2/(2*meff*a^2)/e*1e3;  v0=V0/E0;
  pqrec = @(x) v0*(abs(x)>.5);
  delta=Lb/N; xb=-Lb/2+Lb/N*(0:N);

  options.disp =0 ;

  vn=pqrec(xb);

  %sparce matrix 3PS :
  ee=ones(N+1,1); Lap= spdiags([ee -2*ee ee],[-1 0 1],N+1,N+1);
  A=-1/pi^2/delta^2*Lap+spdiags(vn.',0,N+1,N+1);
  [psi,En]=eigs(A,nmod, 'sm',options);
  En=E0*sort(diag(En));

  endfunction
