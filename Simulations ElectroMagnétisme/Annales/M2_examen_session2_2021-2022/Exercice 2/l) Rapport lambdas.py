# -*- coding: utf-8 -*-
"""
Created on Sat Nov 19 14:19:14 2022

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

# Variables pour mesure des paquets d'onde
# tableaux : 
#[indice position, instant début passage, insant fin passage] = [int, temps(s), temps(s)]

Air = [0, 0., 0.] # Dans l'air
Milieu = [0, 0., 0.] # Dans le milieu

intervalle_air = 0
transition_milieux2 = 0

# Détermination des points de calcul
for i in range(nbx):
    if(eps_r[i] != 1):
        intervalle_air = i-1
        break

for j in range(intervalle_air+1, nbx):
    if(eps_r[j] != n_milieu**2):
        transition_milieux2 = j
        break
    
intervalle_milieu = transition_milieux2 - intervalle_air
                              
Air[0] = int(intervalle_air/7)

Milieu[0] = int(transition_milieux2 - 6*intervalle_milieu/7)



print("\n--------------------\nPoints de mesure (m)\n--------------------")
print("\nDans l'air : \nx = ", Air[0]*dx)
print("Dans le milieu : \nx' = ", Milieu[0]*dx,"\n")

print("\nDébut simulation\n")

# Boucle temporelle principale
for n in range(int(nbt/2)):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    # Détections passage de l'onde dans l'air
    if un_sup[Air[0]] > epsilon and Air[1] == 0:
        Air[1] = t_sup - dt
        print("Mesure 1 dans l'air effectuée\n")
    if un_sup[Air[0]] < epsilon and Air[2] == 0 and Air[1] != 0:
        Air[2] = t_sup - dt
        print("Mesure 2 dans l'air effectuée\n")
        
    # Détection passe de l'onde dans le milieu    
    if un_sup[Milieu[0]] > epsilon and Milieu[1] == 0:
        Milieu[1] = t_sup - dt
        print("Mesure 1 dans le milieu effectuée\n")    
    if un_sup[Milieu[0]] < epsilon and Milieu[2] == 0 and Milieu[1] != 0:
        Milieu[2] = t_sup - dt
        print("Mesure 2 dans le milieu effectuée\n")
    
    # Onde venant de la gauche :
    un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 8.2*T)**2 / (3.2*T)**2 )
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]

print("Fin simulation\n\n")

print("---------------------\nRésultats mesures (s)\n---------------------")

print("\nL'onde est passée \npar x à t1 = ", Air[1], "\n et est partie à t2 = ", Air[2])
print("\nL'onde est passée \npar x' à t'1 = ", Milieu[1], "\n et est partie à t'2 = ", Milieu[2], "\n")

# Vitesse numérique air
C1 = 2 * np.arcsin(np.sin(np.pi*S/N_lambda)/S)
C2 = 2 * np.pi/(lambda_0*(C1/dx))
vph_num = C2*c

# Vitesse numérique dans milieu
vph_num_milieu = vph_num/n_milieu

# Calcul longeurs des paquets dans air et milieu 
paquet_air = (Air[2]-Air[1]) * vph_num
paquet_milieu = (Milieu[2]-Milieu[1]) * vph_num_milieu

print("\nLongueur paquet d'onde dans l'air : ", paquet_air)
print("Longueur paquet d'onde dans le milieu : ", paquet_milieu)

print("\nRapport des longeurs : ", paquet_air/paquet_milieu) 

# Limites visuelles du point de mesure dans l'air
plt.vlines(Air[0]*dx, -1, 1, colors='r', linestyle='dashed')

# Limites visuelles du point de mesure dans le milieu
plt.vlines(Milieu[0]*dx, -1, 1, colors='b', linestyle='dashed')

plt.show()

