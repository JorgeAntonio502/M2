# -*- coding: utf-8 -*-
"""
Created on Tue Nov  1 14:25:41 2022

@author: Utilisateur
"""

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

# Limites d'espace
xmin = -2
xmax = 2
xstep = 0.2

ymin = -7
ymax = 7
ystep = 0.5

# Creation arrays
x = np.arange(xmin, xmax, xstep)
y = np.arange(ymin, ymax, ystep)

# Creation maillage et calcul de la fonction
X, Y = np.meshgrid(x, y)

Z = np.log(3*X**2 + Y**2 + 1)

# Affichage
plt.pcolormesh(X, Y, Z, shading="gouraud")
plt.colorbar()
plt.title("f(x, y) = ln(3x² + y² + 1)")
plt.xlabel("x")
plt.ylabel("y")

plt.show()

# Affichage en 3D :

ax = plt.axes(projection = "3d")
ax.plot_surface(X, Y, Z, cmap = "plasma")
ax.set_xlabel("x")
ax.set_ylabel("y")
ax.set_zlabel("log(3x² + y² + 1)")
ax.set_title("Just a simple 3d plot")
ax.view_init(30, 60)

plt.show()