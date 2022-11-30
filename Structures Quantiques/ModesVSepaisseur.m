clear

aa = linspace(1, 10, 100)*1e-9;
V0 = 400; N = 1e5; Lb = 15; nmodes = 3;

for p = 1:length(aa), a=aa(p),
	EEn(:,p) = PQRECT(V0,a,N,Lb,nmodes);
end

EEn(EEn>0) = nan
plot(aa, EEn, 'Linewidth', 2);
