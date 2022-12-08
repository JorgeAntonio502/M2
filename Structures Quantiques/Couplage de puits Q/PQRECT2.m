function[En] = PQRECT2(V0,a,d,N,Lb,nmodes)

	% Constantes du problème
	me = 9.1091e-31; meff = 0.067*me; e = 1.602176565e-19; hbar = 6.626e-34/2/pi;
	E0 = hbar^2*pi^2/(2*meff*a^2)/e*1e3;
	v0 = V0/E0;
	db = d/a;
	
	pqrec2 = @(x) v0*(x<-1-db/2)+v0*(x>-db/2 & x<db/2)+v0*(x>1+db/2);
	
	delta = Lb/N;
	xb = -Lb/2 + Lb/N * (0:N);
	
	%---------Profil-----------
	vn = pqrec2(xb);
	%--------------------------

	am2 = -1/12/delta^2;
	ap2 = am2;
	am1 = 4/3/delta^2;
	ap1 = am1;
	a0 = -5/2/delta^2;
	
	options.disp = 0;
	
	ee = ones(N+1,1); 
	Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
	
	A = -1/pi^2/delta^2*Lap+spdiags(vn.', 0, N+1, N+1);
	
	[psi, En] = eigs(A, nmodes, 'sm', options);
	En = E0*sort(diag(En));
