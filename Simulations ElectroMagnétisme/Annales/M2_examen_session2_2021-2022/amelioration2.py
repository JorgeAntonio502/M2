# -*- coding: utf-8 -*-
"""
Created on Sat Nov 19 14:19:14 2022

@author: Utilisateur
"""

"""
Amélioration sur N_lambda
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 20
eps_air = 1 
T = lambda_0 / c

# Creation limites figure
fig = plt.figure()
line, = plt.plot([], [])

# Nombre de positions
xmin = 0
xmax = 14*lambda_0
L = xmax-xmin
plt.xlim(xmin, xmax)
plt.ylim(-2, 2)

# Pas et facteur de stabilité
dx = lambda_0 / N_lambda
S = 0.7
dt = (S * dx) / c

# Valeurs abscisses
nbx = int(L / dx)
x = np.linspace(xmin, xmax, nbx)

# Nombre valeurs temporelles
nbt = 2 * int((xmax/lambda_0) * T / dt)

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)

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
    un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 4.3*T)**2 / (1.3*T)**2 )

    line.set_data(x, un_sup)
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = nbt, interval = 3, repeat = False)

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

