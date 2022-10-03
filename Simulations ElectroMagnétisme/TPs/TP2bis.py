# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 18:55:17 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt

print("integration numerique par la methode des rectangles avec alpha = a")
print("\n")

xmin = 0
xmax = 3*np.pi/2
nbx = 20
nbi = nbx - 1 # nombre d'intervalles

x = np.linspace(xmin, xmax, nbx)
y = np.cos(x)
plt.plot(x,y,"bo-")

integrale = 0 
for i in range(nbi):
    integrale = integrale + y[i]*(x[i+1]-x[i])
    # dessin du rectangle
    x_rect = [x[i], x[i], x[i+1], x[i+1], x[i]] # abscisses des sommets
    y_rect = [0   , y[i], y[i]  , 0     , 0   ] # ordonnees des sommets
    plt.plot(x_rect, y_rect,"r")
print("integrale =", integrale)

plt.show()

print("\n")
print("integration numerique par la methode des rectangles avec alpha = b")
print("\n")

xmin = 0
xmax = 3*np.pi/2
nbx = 20
nbi = nbx - 1 # nombre d'intervalles

x = np.linspace(xmin, xmax, nbx)
y = np.cos(x)
plt.plot(x,y,"bo-")

integrale = 0
for i in range(nbi):
    integrale = integrale + y[i+1]*(x[i+1]-x[i])
    # dessin du rectangle
    x_rect = [x[i], x[i], x[i+1], x[i+1], x[i]] # abscisses des sommets
    y_rect = [0   , y[i+1], y[i+1]  , 0     , 0   ] # ordonnees des sommets
    plt.plot(x_rect, y_rect,"r")
print("integrale =", integrale)

plt.show()

print("\n")
print("Méthode des trapèzes :")
print("\n")


xmin = 0
xmax = 3*np.pi/2
nbx = 20
nbi = nbx - 1 # nombre d'intervalles

x = np.linspace(xmin, xmax, nbx)
y = np.cos(x)
plt.plot(x,y,"bo-")

integrale = 0
for i in range(nbi-1):
    integrale = integrale + (x[i+1] - x[i])/2 * (y[i] + y[i+1])
    # dessin du trapèze
    x_rect = [x[i], x[i], x[i+1], x[i+1], x[i]] # abscisses des sommets
    y_rect = [0   , y[i+1], y[i+2] , 0     , 0   ] # ordonnees des sommets
    plt.plot(x_rect, y_rect,"r")
print("integrale =", integrale)

plt.show()