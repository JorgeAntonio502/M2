# -*- coding: utf-8 -*-
"""
Created on Tue Nov  1 14:36:24 2022

@author: Utilisateur
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

x = np.linspace(-3, 13, 161) # nombre de points à calculer selon x
t = np.linspace(0, 4, 41)

fig = plt.figure() 
plt.xlim(-3, 13)
plt.ylim(0, 1)
line, = plt.plot([], [])


def animate(i): 
    # i est le temps ici
    y = (1/(1 + (x - 4.8*i)**2)) # calcul du y au temps i
    
    line.set_data(x, y) #tracé de la courbe au temps i
    return line,
 
ani = animation.FuncAnimation(fig, func = animate, frames = t,
                              interval = 20, repeat = True)
plt.show()
