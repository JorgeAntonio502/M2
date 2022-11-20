# -*- coding: utf-8 -*-
"""
Created on Sat Nov 19 14:19:14 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt


# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 25
eps_air = 1 
T = lambda_0 / c

# Nombre de positions
xmin = 0
xmax = 25*lambda_0 # Augmentation du domaine
L = xmax - xmin

# Pas et facteur de stabilité
dx = lambda_0 / N_lambda
S = 1
dt = (S * dx) / c

# Valeurs abscisses
nbx = int(L / dx)
x = np.linspace(xmin, xmax, nbx)

# Nombre valeurs temporelles
nbt = int(1.7 * (xmax/lambda_0) * T / dt)

# Paramètres milieu transparent
n_milieu = 2
lambda_milieu = lambda_0/n_milieu
largeur_milieu = lambda_milieu/4

# Transmission pour l'interface air/milieu (Fresnel)
t_1 = (2 * 1) / (1 + n_milieu)
print("Interface air/lame : t_air = ", t_1)

# Transmission pour l'interface milieu/air
t_2 = (2 * n_milieu) / (1 + n_milieu)
print("Interface milieu/air : t_milieu = ", t_2)

"""
Lors de la traversée d'une couche du milieu diaélectrique, on a le champ
incident multiplié par le coefficient de transmission entre l'interface air/milieu
et par le coefficient de transmission de l'interface milieu/air. 

Au final, on a donc un facteur t_1*t_2 devant le champ incident.

Pour n traversées de couches, on aura un facteur (t_1*t_2)^n 
"""

# nombre de couches
N_couches = 50

# arrays pour données
N = []
T = []


for i in range(N_couches):
    N.append(i)
    print((t_1*t_2)**i)
    T.append((t_1*t_2)**i) 

T = np.log(T)

plt.plot(N, T)
plt.show()
