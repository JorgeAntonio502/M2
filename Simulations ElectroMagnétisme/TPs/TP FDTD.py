# -*- coding: utf-8 -*-
"""
Created on Wed Sep 28 10:28:48 2022

@author: 1936f
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes
lambda_0 = 1.55e-6
Nlambda = 20
c = 2.99792458e8    

# Limites du graphe selon x
xmin = 0
xmax = 1000*lambda_0
# Limites selon y
ymin = -5
ymax = 5

# Carractéristiques du milieu transparent
n_milieu = 1.45
eps_milieu = n_milieu**2
lim_min = 600*lambda_0
lim_max = 800*lambda_0


nbx = 200
nbt = 300

# Pas temporels et d'espace
dx = lambda_0/Nlambda 
S = 1 # facteur de stabilité numérique, stable si < 1 seulement
dt = (dx * S) / c
T = lambda_0/c


x = np.linspace(xmin, xmax, nbx) # liste des valeurs selon x


eps_r = np.ones(nbx) # tableau contenant les valeurs de eps_r pour les différents x
for i in range(nbx):
    if x[i] > lim_min and x[i] < lim_max :
        eps_r[i] = eps_milieu
        

unm = np.zeros(nbx) # liste des positions à t-1
un = np.zeros(nbx) # liste des positions à t
unp = np.zeros(nbx) # liste des positions à t+1


fig = plt.figure() # initialise la figure
line, = plt.plot([], [])  # plt() renvoie une LISTE des courbes tracées
                          # la virgule récupère la référence à l'objet de la liste


# Creation limites visuelles du milieu
plt.vlines(lim_min, ymin, ymax, linestyles ="dashed", colors ="k")    
plt.vlines(lim_max, ymin, ymax, linestyles ="dashed", colors ="k")


# Limites d'abscisses et l'ordonnées
plt.xlim(xmin, xmax)
plt.ylim(ymin, ymax)

                          
def animate(n):
    
    # Applicatin du schéma numérique
    for i in range(1, nbx-1):
        unp[i] = S**2/eps_r[i] * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - unm[i] # Calcul de la valeur à la position i à t+1
    
    
    tnp = (n+1) * dt # Car on veut la valeur du temps à t_n+1 (dépend de l'origine du temps)
    
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

ani = animation.FuncAnimation(fig, func = animate,
                              interval=30, blit=True, repeat=False)

plt.show()

"""
# Correction :
    
c = ...
lambda0 = 1.55e-6

xmin = 0
xmax = 10*lambda0

N_lambda = 20
dx = lambda0 / N_lambda

nbx = int ((xman-xmin)/dx) + 1

dt = S * dx / c

T = lambda0 / c

unm = np.zeros(nbx) 
un = np.zeros(nbx) # Identique à E(x, t)
unp = np.zeros(nbx) 

# dans animation() :
    
    tnp = (n+1) * dt
    unp[0] = formule...
    
    
"""

