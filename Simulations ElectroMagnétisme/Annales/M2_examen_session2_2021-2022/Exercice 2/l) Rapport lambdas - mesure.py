# -*- coding: utf-8 -*-
"""
Created on Sat Nov 19 14:19:14 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

epsilon = 10e-5

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 34
eps_air = 1 
T = lambda_0 / c
k_0 = (2*np.pi)/(T*c)

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

# Détermination des tailles des milieux
transition1 = 0
transition2 = 0

for i in range(nbx):
    if(eps_r[i] != 1):
        transition1 = i-1
        break

for j in range(transition1+1, nbx):
    if(eps_r[j] != n_milieu**2):
        transition2 = j
        break
    
intervalle_air_milieu = transition1
intervalle_milieu_air = transition2 - transition1

# Définition des points de mesure
x_air = int(intervalle_air_milieu/10)
t1_air = 0
t2_air = 0

x_milieu = int(transition1 + intervalle_milieu_air/10)
t1_milieu = 0
t2_milieu = 0
    
# Boucle temporelle principale
for n in range(int(nbt/2)):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    # Mesures de temps dans l'air
    if un_sup[x_air] > epsilon and t1_air == 0:
        t1_air = t_sup - dt
        print("Mesure 1 dans l'air effectuée\n")
    if un_sup[x_air] < 0 and un_sup[x_air] > -epsilon and t2_air == 0:
        t2_air = t_sup - dt
        print("Mesure 2 dans l'air effectuée\n")
        
    # Mesures de temps dans le milieu
    if un_sup[x_milieu] > epsilon and t1_milieu == 0:
        t1_milieu = t_sup - dt
        print("Mesure 1 dans le milieu effectuée\n")
    if un_sup[x_milieu] < 0 and un_sup[x_milieu] > -epsilon and t2_milieu == 0:
        t2_milieu = t_sup - dt
        print("Mesure 2 dans le milieu effectuée\n")
    
    if t_sup < 25*T:
        # Onde venant de la gauche :
        un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 8.2*T)**2 / (3.2*T)**2 )
    else:
        # Pour que l'onde parte à l'infini à gauche
        un_sup[0] = un[1]
    
    # Pour que l'onde parte à l'infini à droite
    un_sup[nbx-1] = un[nbx-2] 
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    

print("Fin simulation\n\n")
    
print("---------------------\nRésultats mesures (s)\n---------------------")

print("\nL'onde est passée : \n\npar x1 à t1 = ", t1_air, "\npar x2 à t2 = ", t2_air)
print("\npar x'1 à t'1 = ", t1_milieu, "\npar x'2 à t'2 = ", t2_milieu, "\n")

# Vitesses de phases numériques
C1 = 2 * np.arcsin(np.sin(np.pi*S/N_lambda)/S)
C2 = 2 * np.pi/(lambda_0*(C1/dx))

vph_num_air = C2*c
vph_num_milieu = vph_num_air/n_milieu

# Calcul de la distance dans les milieux
L_air = ((t2_air - t1_air)*dx) * vph_num_air
L_milieu = ((t2_milieu - t1_milieu)*dx) * vph_num_milieu

print("----------------------\nLongueurs mesurées m\n----------------------")

print("\nDans l'air : L_air = ", L_air)
print("\nDans le milieu : L_milieu = ", L_milieu)
print("\n\n => Rapport : n = L_air/L_milieu = ", L_air/L_milieu)


# Limites visuelles des points de mesure dans l'air
plt.vlines(x_air*dx, -1, 1, colors='r', linestyle='dashed')

# Limites visuelles des points de mesure dans le milieu
plt.vlines(x_milieu*dx, -1, 1, colors='b', linestyle='dashed')

plt.show()

