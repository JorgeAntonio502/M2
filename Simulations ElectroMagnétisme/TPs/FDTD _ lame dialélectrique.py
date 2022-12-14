# -*- coding: utf-8 -*-
"""
Created on Wed Sep 28 10:28:48 2022

@author: 1936f
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

"""
A = 3
sigma = 1
mu = 10
"""
nbx = 200
nbt = 300

c = 1    # vitesse lumière
dt = 0.1 # pas temporel
S = 1 # facteur de stabilité numérique, stable si < 1 seulement
dx = (c*dt)/S # pas d'espace

tc = 30*dt
tau = 10*dt

xmin = 0
xmax = (nbx-1) * dx + dx + xmin

x = np.linspace(xmin, xmax, nbx) # liste des valeurs selon x
unm = np.zeros(nbx) # liste des positions à t-1
un = np.zeros(nbx) # liste des positions à t
unp = np.zeros(nbx) # liste des positions à t+1

fig = plt.figure() # initialise la figure
line, = plt.plot([], [])  # plt() renvoie une LISTE des courbes tracées
                          # la virgule récupère la référence à l'objet de la liste
                         
                          
plt.xlim(xmin, xmax)
plt.ylim(-2, 2)
                          
def animate(n):
    for i in range(1, nbx-1):
        unp[i] = S**2 * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - unm[i] # Calcul de la valeur à la position i à t+1
        
        
    """
    # Fonction porte
    if n > 10 and n < 50:
        unp[0] = 1
    else:
        unp[0] = 0
    """
    
    """
    # Tentative personnelle pour Gaussienne
    # Condition pour que toute la gaussienne soit visible
    if n > 0 and n < nbx: 
        unp[0] = A*np.exp(-(x[n]-mu)**2/2*sigma**2) / (sigma*np.sqrt(2*np.pi))
    else :
        unp[0] = 0
    """    
        
    # Correction Gaussienne    
    tnp = (n+1) * dt # Car on veut la valeur du temps à t_n+1 (dépend de l'origine du temps)
    unp[0] = np.exp( -( (tnp-tc)/tau)**2 )
    
    
    line.set_data(x, unp)
    
    unm[:] = un[:]
    un[:] = unp[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate,
                              interval=3, blit=True, repeat=False)

plt.show()