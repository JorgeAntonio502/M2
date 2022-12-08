clear;
dd = linspace(.1, 20, 100)*1e-9;
a = 5e-9;
V0 = 400;
N = 1e4;
Lb = 15;
nmodes = 4;

for p = 1:length(dd), d = dd(p);
	EEn(:,p) = PQRECT2(V0,a,d,N,Lb,nmodes);
end

EEn(EEn > V0) = nan;
plot(dd*1e9, EEn,'Linewidth', 2);
