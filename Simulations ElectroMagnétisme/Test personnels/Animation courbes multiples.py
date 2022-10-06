# -*- coding: utf-8 -*-
"""
Created on Thu Oct  6 08:35:38 2022

@author: Utilisateur
"""

#from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

L = 10 # Largeur du puits
A = np.sqrt(2/L)

def phi(x, n):
    return A*np.sin(n*np.pi*x/L)
    

x_values = np.linspace(0, L, 200)
x = []

y1, y2, y3 = [], [], []

fig, axes = plt.subplots()

l1 = phi(x_values, 1) 
l2 = phi(x_values, 2) 
l3 = phi(x_values, 3) 

"""
axes.plot(x_values, l1)
axes.plot(x_values, l2)
axes.plot(x_values, l3)

plt.vlines(0, -A, A, linestyles = "solid", colors = "k")
plt.vlines(L, -A, A, linestyles = "solid", colors = "k")

plt.show()
"""

plt.vlines(0, -A, A, linestyles = "solid", colors = "k")
plt.vlines(L, -A, A, linestyles = "solid", colors = "k")

def animate(i):
    
    x.append(x_values[i])
    
    y1.append(l1[i])
    y2.append(l2[i])
    y3.append(l3[i])
        
    axes.plot(x, y1)
    axes.plot(x, y2)
    axes.plot(x, y3)
    
ani = animation.FuncAnimation(fig, func = animate, frames = 200, interval = 1, repeat = False)
    
plt.show()