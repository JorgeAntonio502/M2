# -*- coding: utf-8 -*-
"""
Created on Sat Sep 17 18:30:52 2022

@author: Utilisateur
"""

L = 5 # Longeur des côtés du triangle équilatéral

import numpy as np
import matplotlib.pyplot as plt
import random
import matplotlib.animation as animation

# Tracé du triangle

x_triangle = np.array([0, L,       L/2         , 0]) # abscisses des sommets
y_triangle = np.array([0, 0, (np.sqrt(3)*L)/2. , 0]) # ordonnees des sommets (formule trouvée via pythagore)

plt.plot(x_triangle, y_triangle,"r") # Tracé du triangle


# Création arbitraire du premier point :
    
x0 = np.array([3.5])
y0 = np.array([1.7])

plt.plot(x0[0], y0[0], "k", marker="o", markeredgecolor="red", markerfacecolor="green") # Tracé du point


# Calcul des coordonnées des autres points 

nb = 2000

for i in range(nb):
    n = random.randint(1, 3)
    if n == 1:
        x0[0] = (x0[0] + x_triangle[0])/2.
        y0[0] = (y0[0] + y_triangle[0])/2. 
    elif n == 2:
        x0[0] = (x0[0] + x_triangle[1])/2.
        y0[0] = (y0[0] + y_triangle[1])/2.
    else :
        x0[0] = (x0[0] + x_triangle[2])/2.
        y0[0] = (y0[0] + y_triangle[2])/2.
    plt.plot(x0[0], y0[0], "k", marker="o", markeredgecolor="red", markerfacecolor="green") # Tracé du nouveau point calculé
    
plt.axis("equal")


# Correction

Sx = np.array([-0.5, 0.5,      0      , -0.5])
Sy = np.array([   0,   0, np.sqrt(3)/2,    0])
plt.plot(Sx, Sy)
plt.axis("equal")

x0 = 0.1
y0 = 0.15

plt.plot(x0, y0, ",b")

while True:
    for i in range(50):
            n = int(np.random.random()*3)
            x0 = (x0 + Sx[n])/2
            y0 = (y0 + Sy[n])/2
            plt.plot(x0, y0, ",b")
            plt.pause(0.01)

plt.show()




