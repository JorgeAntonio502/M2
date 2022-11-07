# -*- coding: utf-8 -*-
"""
Created on Tue Nov  1 14:31:21 2022

@author: Utilisateur
"""
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

x = np.linspace(-3, 3, 101)
z = np.exp(-2j*np.pi*x) + np.exp(-x**2) # La fonction complexe

X = np.array([x,x])

y0 = np.zeros(len(x))
y = np.abs(z)                       # Le module de la fonction complexe
Y = np.array([y0,y])

Z = np.array([z,z])
C = np.angle(Z)

plt.plot(x, y, "k")

plt.pcolormesh(X, Y, C, shading="gouraud", cmap=plt.cm.hsv, vmin=-np.pi, vmax=np.pi)
plt.colorbar()

plt.show()