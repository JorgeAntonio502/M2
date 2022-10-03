# -*- coding: utf-8 -*-
"""
Created on Wed Sep 14 10:55:44 2022

@author: 1936f
"""
import random
import numpy as np
import matplotlib.pyplot as plt

N = 500   # Nombre de marcheurs
n = 200 # Nombre de pas

x = np.zeros(n)      # Position
x2 = np.zeros(n)     # Carré position à l'origine
x_moy = np.zeros(n)  # Moyenne des carrés pour N marcheurs

x_i = 0   # position initiale
x[0] = x_i


for j in range(N) :  # Chaque tour de boucle représente un marcheur
    
    for i in range(1, n, 1):  # Simulation de la marche aléatoire
        if random.random() < 0.5 :
            x_i = x_i + 1     # Nouvelle position
        else :
            x_i = x_i - 1
        x[i] = x_i
        x2[i] = (x_i-x[0])**2 # Carré de la distance à l'origine
        x_moy[i] = x_moy[i] + x2[i]
        
    
    x_i = 0   # Remise de l'origine à 0 pour le marcheur suivant
    

x_moy = x_moy/N

plt.plot(x_moy, "k")
plt.title("Moyenne des carrés à l'origine")
plt.xlabel("t")
plt.ylabel("Position")

plt.show()



# Correction marche 1D

nbpos = 200
nbmarcheurs = 500

pos = np.zeros(nbpos)
pas = range(nbpos)

somme = np.zeros(nbpos)

for m in range(nbmarcheurs):
    x = 0
    for i in range(1, nbpos):
        if np.random.random() > 0.5:
            x += 1
        else:
            x -= 1
        pos[i] = x
    somme += pos**2  # Utilisation de la vectorisation
        
plt.plot(pas, somme/nbmarcheurs)
plt.show()




