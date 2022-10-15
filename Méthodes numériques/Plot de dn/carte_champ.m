clear all

R = 2

x0 = 3
y0 = 3

Nx = 100
Ny = 100

[x, y] = meshgrid(linspace(-x0, x0, Nx), linspace(-y0, y0, Ny));

z = 

r = abs(z)
teta = angle(z)

pcolor(x, y, abs(z))
shading flat
pause
