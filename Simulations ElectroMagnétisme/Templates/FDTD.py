# -*- coding: utf-8 -*-
"""
Basic script for FDTD
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes
c = 2.99792458e8
lambda_0 = 1.55e-6

# Variables
N_lambda = 20
T = lambda_0/c

dx = lambda_0/N_lambda
S = 1
dt = S*dx/c

# Limites d'espace
xmin = 0
xmax = 15*lambda_0
nbx = 200
x = np.linspace(xmin, xmax, nbx)

ymin = -1
ymax = 1

# Limites de temps
tmin = 0
tmax = 1000
t = np.arange(tmin, tmax)

# listes des positions aux instants n-1, n et n+1
unm = np.zeros(nbx)
un = np.zeros(nbx)
unp = np.zeros(nbx)

# constantes diaélectrique
eps_r = np.ones(nbx)

# Creation milmieu d'indice n_milieu
n_milieu = 1.5
lim_min = xmax/2 - lambda_0
lim_max = xmax/2 + lambda_0
for i in range(nbx):
    if x[i] > lim_min and x[i] < lim_max:
        eps_r[i] = n_milieu

      
# Coefficients de Fresnel
Reflex = (1 - n_milieu)/(1 + n_milieu) # Négatif si les max deviennent des min
Transm = 2*1 / 1 + n_milieu
print("Interface air/milieu : r = ", Reflex, " t = ", Transm)

Reflex = (n_milieu - 1)/(1 + n_milieu)
Transm = 2 * n_milieu / (1 + n_milieu)
print("Interface milieu/air : r = ", Reflex, " t = ", Transm)

# Création et paramétrage figure 
fig = plt.figure()
line, = plt.plot([], [])

# Limites d'abscisses et l'ordonnées
plt.xlim(xmin, xmax)
plt.ylim(ymin, ymax)

# Creation limites visuelles du milieu
plt.vlines(lim_min, ymin, ymax, linestyles ="dashed", colors ="k")    
plt.vlines(lim_max, ymin, ymax, linestyles ="dashed", colors ="k")

def animate(n):
    
    for i in range(1, nbx-1):
        unp[i] = S**2/eps_r[i] * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - unm[i] # Calcul de la valeur à la position i à t+1
    
    # Calcul du temps supérieur
    tnp = (n + 1) * dt
    
    # Onde venant de la droite
    #unp[0] = np.cos((2*np.pi/T)*tnp) * np.exp(-((tnp - 3*T)/T)**2)
    
    # Onde venant de la gauche
    #unp[nbx-1] = np.cos((2*np.pi/T)*tnp) * np.exp(-((tnp - 3*T)/T)**2)
    
    if tnp < 6*T:
        # Equation onde :
        unp[0] = np.cos((2*np.pi/T)*tnp) * np.exp(-((tnp - 3*T)/T)**2)
    else:
        unp[0] = un[1]  # Pour que l'onde parte à l'infini à gauche
        
    unp[nbx-1] = un[nbx-2] # Pour que l'onde parte à l'infini à droite
    
    line.set_data(x, unp)
    
    unm[:] = un[:]
    un[:] = unp[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = t,
                              interval=30, blit=True, repeat=False)

plt.show()

 
