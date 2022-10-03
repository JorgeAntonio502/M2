# -*- coding: utf-8 -*-
"""
Created on Wed Sep 28 10:28:48 2022

@author: 1936f
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

t_sup = np.linspace(0, 4, 400)
t = np.linspace(0, 4, 400)
t_inf = np.linspace(0, 4, 400)

c = 1 # vitesse lumière

nbx = 200
nbt =300

dt = 0.1
S = 1

dx = c * dt / S

unm = np.zeros(nbx) # t-1
un = np.zeros(nbx) # t
unp = np.zeros(nbx) # t+1

xmin = 0
xmax = (nbx-1) * dx + dx + xmin
x = np.linspace(xmin, xmax, nbx)


fig = plt.figure() # initialise la figure
line, = plt.plot([], [])  # plt() renvoie une LISTE des courbes tracées
                          # la virgule récupère la référence à l'objet de la liste
                          
plt.xlim(xmin, xmax)
plt.ylim(-2, 2)
                          
def animate(n):
    for i in range(1, nbx-1):
        unp[i] = S**2 * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - unm[i] 
    
    if n > 10 and n < 30:
        unp[0] = 1
    else:
        unp[0] = 0
        
    line.set_data(x, unp)
    
    unm[:] = un[:]
    un[:] = unp[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate,
                              interval=1, blit=True, repeat=False)

plt.show()