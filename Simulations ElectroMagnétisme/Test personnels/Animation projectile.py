# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

def F1x(vx):
    return vx

def F2x(alpha, mass, vx):
    return -(alpha/mass)*vx

def F1y(vy):
    return vy

def F2y(alpha, mass, g, vy):
    return -(alpha/mass)*vy -g



"""
Les variables déclarées ci-dessous sont globales car hors du main ou d'une fonction. 
"animate" peut donc y accéder sans avoir à les passer en paramètres
"""

x_data = [] # Mieux que les arrays dans ce cas
y_data = []

vx = []
vy = []

x_min = 0
x_max = 50
step = 1

y_min = 0
y_max = 50

alpha = 1
m = 1
g = 9.8
dt = 0.1
N = 1000

theta = np.pi / 3
v0 = 50

x0 = 0.
y0 = 0.

x_data.append(x0)
y_data.append(y0)

vx0 = v0*np.cos(theta)
vy0 = v0*np.sin(theta)

vx.append(vx0)
vy.append(vy0)

fig = plt.figure() # initialise la figure
line, = plt.plot([], [])  # graphe vide

def animate(i): 
    x_data.append(x_data[i-1] + dt*F1x(vx[i-1]))
    vx.append(vx[i-1] + dt*F2x(alpha, m, vx[i-1]))
    
    y_data.append(y_data[i-1] + dt*F1y(vy[i-1]))
    vy.append(vy[i-1] + dt*F2y(alpha, m, g, vy[i-1]))
    
    line.set_data(x_data, y_data) # Mise à jour du graphe
    
    return line,
    
ani = animation.FuncAnimation(fig, func = animate, frames = np.arange(0, N, 1),
                              interval=1, blit=True, repeat=False)
    
plt.xlim(x0, 50)
plt.ylim(y0, 50)

plt.show()