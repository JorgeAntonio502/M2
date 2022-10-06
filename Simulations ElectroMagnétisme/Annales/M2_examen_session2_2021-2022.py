# -*- coding: utf-8 -*-
"""
Created on Wed Oct  5 15:50:40 2022

@author: Utilisateur
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

"""
Exercice 1 : Visualisation
"""

epsilon = np.finfo(float).eps

# La fonction
def f(x, t) :
    return 1 / (1 + (x - 5*t)**2)

# Données d'espace
xmin = -2
xmax = 15
nbx = 171

# Données temporelles
tmin = 0
tmax = 3
nbt = 31

# array d'espace et de temps
x = np.linspace(xmin, xmax, nbx)
time = np.linspace(tmin, tmax, nbt)

# Initialisation de la figure
fig = plt.figure()
line, = plt.plot([], [])

plt.xlim(xmin, xmax)
plt.ylim(-5, 5)

# Animation 
def animate(t):
    
    y = f(x, t)
    
    line.set_data(x, y)
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = time, repeat =False)

plt.show()


"""
Exercice 2 : Simulation FDTD 1D
"""






