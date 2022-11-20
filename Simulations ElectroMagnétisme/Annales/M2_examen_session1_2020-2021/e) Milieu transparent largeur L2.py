# -*- coding: utf-8 -*-
"""
Created on Sat Nov 19 14:19:14 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 25
eps_air = 1 
T = lambda_0 / c

# Creation limites figure
fig = plt.figure()
line, = plt.plot([], [])

# Nombre de positions
xmin = 0
xmax = 25*lambda_0
L = xmax - xmin

plt.xlim(xmin, xmax)
plt.ylim(-2, 2)

# Pas et facteur de stabilité
dx = lambda_0 / N_lambda
S = 1
dt = (S * dx) / c

# Valeurs abscisses
nbx = int(L / dx)
x = np.linspace(xmin, xmax, nbx)

# Nombre valeurs temporelles
nbt = int(1.7 * (xmax/lambda_0) * T / dt)

# Paramètres milieu transparent
n_milieu = 2
lambda_milieu = lambda_0/n_milieu
largeur_milieu = lambda_milieu/4

debut_milieu = L/2 - largeur_milieu/2
fin_milieu = L/2 + largeur_milieu/2

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)
for i in range(nbx):
    if(x[i] >= debut_milieu and x[i]  <= fin_milieu):
        eps_r[i] = n_milieu**2
        
# Limites visuelles du milieu
plt.vlines(debut_milieu, -2, 2, colors='k', linestyle='dashed')
plt.vlines(fin_milieu, -2, 2, colors='k', linestyle='dashed')

# Creation tableaux des positons à t-1, t et t+1
un_inf = np.zeros(nbx)
un = np.zeros(nbx)
un_sup = np.zeros(nbx)


def animate(n):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    # Onde venant de la gauche :
    un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 10*T)**2 / (4*T)**2 )

    line.set_data(x, un_sup)
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = nbt, interval = 3, repeat = False)

# Coefficients de Fresnel
print("Coefficients de Fresnel :")
r = (1 - n_milieu)/(1 + n_milieu) # Négatif si les max deviennent des min
t = (2*1) / (1 + n_milieu)
print("Interface air/milieu : r = ", r, " t = ", t)

r = (n_milieu -1)/(1 + n_milieu)
t = 2 * n_milieu / (1 + n_milieu)
print("Interface milieu/air : r = ", r, " t = ", t, "\n\n")

"""
Calcul des coefficients C1 et C2 tels que :
    k_num = C1/dx
    Vphase_num = C2*c
"""
C1 = 2 * np.arcsin(np.sin(np.pi*S/N_lambda)/S)
C2 = 2 * np.pi/(lambda_0*(C1/dx))
print("k_numérique = ", C1, "/dx")
print("vPhase_numérique = ", C2, ".c\n\n soit\n")

print("k_numérique = ", C1/dx, " Vphase_numérique = ", C2*c)
print("L'erreur sur la vitesse de phase est de : ", (1-C2)*100, " %")

plt.show()

