# -*- coding: utf-8 -*-
"""
Created on Sat Dec  3 19:16:03 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

epsilon = np.finfo(float).eps

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 34
eps_air = 1 
T = lambda_0 / c

# Creation limites figure
fig = plt.figure()
line, = plt.plot([], [])

# Nombre de positions
xmin = 0
xmax = 40*lambda_0
L = xmax - xmin

plt.xlim(xmin, xmax)
plt.ylim(-2, 2)

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
n_milieu = 2.2
lambda_milieu = lambda_0/n_milieu
largeur_milieu = 9.6*lambda_0

debut_milieu = L/2 - largeur_milieu/2
fin_milieu = L/2 + largeur_milieu/2

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)
for i in range(nbx):
    if(x[i] >= debut_milieu and x[i]  <= fin_milieu):
        eps_r[i] = n_milieu**2
        
# Limites visuelles du milieu
plt.vlines(debut_milieu, -2, 2, colors='k', linestyle='dashed')
plt.vlines(fin_milieu, -2, 2, colors='k', linestyle='dashed')

# Creation tableaux des positons à t-1, t et t+1
un_inf = np.zeros(nbx)
un = np.zeros(nbx)
un_sup = np.zeros(nbx)

# Variables pour mesure vitesse numérique
# tableaux : [indice position, instant de passage] = [int, temps(s)]

Air1 = [70, 0.] # Dans l'air
Air2 = [0, 0.] 

Milieu1 = [0, 0.] # Dans le milieu
Milieu2 = [0, 0.]

# Détermination des points de calcul (Limites des milieux)
for i in range(nbx):
    if(eps_r[i] != 1):
        Air2[0] = i-1
        Milieu1[0] = i
        break

for j in range(Milieu1[0], nbx):
    if(eps_r[j] != n_milieu**2):
        Milieu2[0] = j
        break
    
intervalle_air = Air2[0]-Air1[0]
intervalle_milieu = Milieu2[0] - Milieu1[0]
                              
Air1[0] = int(intervalle_air/3)
Air2[0] = int(2*intervalle_air/3)

Milieu1[0] = int(Milieu1[0] + intervalle_milieu/3)
Milieu2[0] = int(Milieu2[0] - intervalle_milieu/3)


print("\n--------------------\nPoints de mesure (m)\n--------------------")
print("\nDans l'air : \nx1 = ", Air1[0]*dx, "\nx2 = ", Air2[0]*dx, "\n")
print("Dans le milieu : \nx'1 = ", Milieu1[0]*dx, "\nx'2 = ", Milieu2[0]*dx, "\n")

print("\nDébut simulation\n")

# Boucle temporelle principale
for n in range(int(nbt/2)):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
            
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    # Détections passage de l'onde dans l'air
    if un_sup[Air1[0]] > epsilon and Air1[1] == 0:
        Air1[1] = t_sup - dt
        print("Mesure 1 dans l'air effectuée\n")
    if un_sup[Air2[0]] > epsilon and Air2[1] == 0:
        Air2[1] = t_sup - dt
        print("Mesure 2 dans l'air effectuée\n")
        
    # Détection passe de l'onde dans le milieu    
    if un_sup[Milieu1[0]] > epsilon and Milieu1[1] == 0:
        Milieu1[1] = t_sup - dt
        print("Mesure 1 dans le milieu effectuée\n")    
    if un_sup[Milieu2[0]] > epsilon and Milieu2[1] == 0:
        Milieu2[1] = t_sup - dt
        print("Mesure 2 dans le milieu effectuée\n")
    
    # Onde venant de la gauche :
    un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 8.2*T)**2 / (3.2*T)**2 )

    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
print("Fin simulation\n\n")
    
print("---------------------\nRésultats mesures (s)\n---------------------")

print("\nL'onde est passée : \n\npar x1 à t1 = ", Air1[1], "\npar x2 à t2 = ", Air2[1])
print("\npar x'1 à t'1 = ", Milieu1[1], "\npar x'2 à t'2 = ", Milieu2[1], "\n")

# Calcul de la vitesse dans le milieu
v_air = ((Air2[0] - Air1[0])*dx) / (Air2[1] - Air1[1])
v_milieu = ((Milieu2[0] - Milieu1[0])*dx) / (Milieu2[1] - Milieu1[1])

print("-------------------------\nVitesses numériques (m/s)\n-------------------------")

print("\nDans l'air : v_air = ", v_air)
print("\nDans le milieu : v_milieu = ", v_milieu)
print("\n\n => Rapport : n = v_air/v_milieu = ", v_air/v_milieu)

# Limites visuelles des points de mesure dans l'air
plt.vlines(Air1[0]*dx, -1, 1, colors='r', linestyle='dashed')
plt.vlines(Air2[0]*dx, -1, 1, colors='r', linestyle='dashed')

# Limites visuelles des points de mesure dans le milieu
plt.vlines(Milieu1[0]*dx, -1, 1, colors='b', linestyle='dashed')
plt.vlines(Milieu2[0]*dx, -1, 1, colors='b', linestyle='dashed')

plt.show()