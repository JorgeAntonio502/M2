function [En] = PQRECT(V0,a,N,Lb,nmodes)
	% function En=PQRECT()

	% Paramètres physiques
	e = 1.602176565e-19;
	%a = 10.e-09;
	%a_bar = 5;
	m_e = 9.1091e-31;
	m_eff = 0.067 * m_e;
	q_e = 1.602176565e-19;
	h_bar = 6.626e-34 / 2 / pi;
	E_0 = h_bar^2 * pi^2 / (2 * m_eff * a^2) / q_e * 1.e03;
	V_0 = 1000 ; v_0 = V_0 / E_0;
	v_A = v_0 ; v_B = 0;

	pqrec = @(x) V_0 * (abs(x)>.5);

	delta = Lb/N;
	xb = -Lb/2 + Lb/N * (0:N);
	
	%---------Profil-----------
	vn = pqrec(xb);
	%--------------------------

	am2 = -1/12/delta^2;
	ap2 = am2;
	am1 = 4/3/delta^2;
	ap1 = am1;
	a0 = -5/2/delta^2;
	
	options.disp = 0;
	
	ee = ones(N+1:1); Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
	
	A = -1/pi^2/delta^2*Lap+spdiags(vn.', 0, N+1, N+1);
	
	[psi, En] = eigs(A, nmodes, 'sm', options);
	En = E0*sort(diag(En));
