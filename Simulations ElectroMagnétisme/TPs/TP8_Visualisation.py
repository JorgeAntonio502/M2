# -*- coding: utf-8 -*-
"""
Created on Sun Sep 18 13:39:40 2022

@author: Utilisateur
"""

import matplotlib.pyplot as plt
import numpy as np
import matplotlib.animation as animation

# a)

epsilon = np.finfo(float).eps
print("epsilon =", epsilon)

xmin = -6
xmax = 6
nbx = 121

x = np.linspace(xmin, xmax, nbx)

y = (np.sin(x+epsilon) / (x+epsilon)) * np.sqrt((x+epsilon)**2 + 1) # epsilon ajouté à x pour annuler l'indétermination en 0

plt.plot(x, y)
plt.title("f(x) = sin(x)*sqrt(x² + 1)/x")
plt.xlabel("x")
plt.ylabel("f(x)")

plt.show()


# b)

xmin = -2
xmax = 2
xstep = 0.2

ymin = -7
ymax = 7
ystep = 0.5

x = np.arange(xmin, xmax, xstep)
y = np.arange(ymin, ymax, ystep)

X, Y = np.meshgrid(x, y)

Z = np.log(3*X**2 + Y**2 + 1)

plt.pcolormesh(X, Y, Z, shading="gouraud")
plt.colorbar()
plt.title("f(x, y) = ln(3x² + y² + 1)")
plt.xlabel("x")
plt.ylabel("y")

plt.show()

# c)

Re_min = -3
Re_max = 3
Re_values = 101

Real = np.linspace(Re_min, Re_max, Re_values) + epsilon
Im = np.linspace(Re_min, Re_max, Re_values)

R, I = np.meshgrid(Real, Im)

Z = np.angle(np.exp(-1j*np.pi*R) * np.exp(-R**2))

plt.pcolormesh(R, I, Z, shading='auto')
plt.colorbar()
plt.xlabel("partie reelle")
plt.ylabel("partie imaginaire")

plt.show()

# d)

x = np.linspace(-3, 13, 161) # nombre de points à calculer selon x

fig = plt.figure() 
plt.xlim(-3, 13)
plt.ylim(0, 1)
line, = plt.plot([], [])

def animate(i): 
    # i est le temps ici
    y = (1/(1 + (x - 4.8*i)**2)) # calcul du y au temps i
    
    line.set_data(x, y) #tracé de la courbe au temps i
    return line,
 
ani = animation.FuncAnimation(fig, func = animate, frames=np.linspace(0, 4, 41),
                              interval=10, repeat = True)
plt.show()