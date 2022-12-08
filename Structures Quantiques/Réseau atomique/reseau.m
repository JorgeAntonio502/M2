clear

% Constantes du problème
a = 10e-9;
me = 9.1091e-31; meff = 0.067*me; e = 1.602176565e-19; hbar = 6.626e-34/2/pi;
E0 = hbar^2*pi^2/(2*meff*a^2)/e*1e3;


V0 = 400;
V0b = V0/E0;
d=linspace(0.01, 10, 100)*1e-9;
nmodes = 50;
options.disp = 0; N = 1e4

Npq = 15;
msq = @(x, a, d) (x > 0 & x <= a);

for p = 2:Npq, 
	msq = @(x, a, d) msq(x, a, d) + (x>=(p-1)*(a+d) & x <= (p-1)*(a+d)+a);
end

msqpq = @(x, a, d) 1 - msq(x, a, d);

xbi = -10;
xbf = (Npq-1)*(1+max(d)/a)+1+10;
delt = (xbf-xbi)/N;
xb = xbi + delt*(0:N);

for pp = 1:length(d); pp
	vn = V0b*msqpq(xb, 1, d(pp)/a);
	
	ee = ones(N+1,1); 
	Lap = spdiags([ee -2*ee ee], [-1 0 1], N+1, N+1);
	
	A = -1/pi^2/delt^2*Lap+spdiags(vn.', 0, N+1, N+1);
	
	[psi, En] = eigs(A, nmodes, 'sm', options);
	En = diag(En);
	En(En>V0b) = nan;
	EE(:,pp) = En*E0;
end

plot(d,EE, 'Linewidth', 2): grid

