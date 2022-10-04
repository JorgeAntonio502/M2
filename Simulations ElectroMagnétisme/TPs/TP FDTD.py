# -*- coding: utf-8 -*-
"""
Created on Wed Sep 28 10:28:48 2022

@author: 1936f
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

lambda_0 = 1.55e-6
Nlambda = 20

n_air = 1
n_milieu = 1.45

eps_r1 = n_air**2
eps_r2 = n_milieu**2

nbx = 200
nbt = 300

c = 2.99792458e8    # vitesse lumière

dx = lambda_0/Nlambda # pas temporel

S = 1 # facteur de stabilité numérique, stable si < 1 seulement
# Ici, S doit être 1 et que de l'air entoure le milieu transparent 

dt = (dx * S) / c



T = lambda_0/c

xmin = 0
xmax = 20*lambda_0

x = np.linspace(xmin, xmax, nbx) # liste des valeurs selon x

eps_r = np.ones(nbx) # tableau contenat les valeurs de eps_r pour les différents x
for i in range(nbx):
    if x[i] > 12*lambda_0 and x[i] < 17*lambda_0 :
        eps_r[i] = 1.45**2 # indice de réfraction au carré

unm = np.zeros(nbx) # liste des positions à t-1
un = np.zeros(nbx) # liste des positions à t
unp = np.zeros(nbx) # liste des positions à t+1

fig = plt.figure() # initialise la figure
line, = plt.plot([], [])  # plt() renvoie une LISTE des courbes tracées
                          # la virgule récupère la référence à l'objet de la liste

                         
                          
plt.xlim(xmin, xmax)
plt.ylim(-2, 2)
                          
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
                              interval=5, blit=True, repeat=False)

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

