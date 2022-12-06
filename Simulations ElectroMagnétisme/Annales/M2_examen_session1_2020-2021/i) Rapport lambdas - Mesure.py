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
N_lambda = 25
eps_air = 1 
T = lambda_0 / c
k_0 = (2*np.pi)/(T*c)

# Creation limites figure
fig = plt.figure()
line, = plt.plot([], [])

# Nombre de positions
xmin = 0
xmax = 25*lambda_0 # Augmentation du domaine
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
n_milieu = 2
lambda_milieu = lambda_0/n_milieu
largeur_milieu = 10*lambda_0

debut_milieu = L/2
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

# Détermination des intervalles des milieux
intervalle_air = 0
intervalle_milieu = 0

transition_milieux1 = 0
transition_milieux2 = 0

for i in range(nbx):
    if(eps_r[i] != 1):
        transition_milieux1 = i-1
        break

for j in range(transition_milieux1+1, nbx):
    if(eps_r[j] != n_milieu**2):
        transition_milieux2 = j
        break
    
intervalle_air = transition_milieux1
intervalle_milieu = transition_milieux2 - transition_milieux1

# Variables pour mesure des paquets d'onde

x_mesure_air = int(intervalle_air/4)
t1_air = 0
t2_air = 0

x_mesure_milieu = int(transition_milieux1 + intervalle_milieu/4)
t1_milieu = 0
t2_milieu = 0

nb_chgt_sign = 0

print("\nOn calcule le rapport des longeurs entre les deux premiers milieux\n")

print("\n--------------------\nPoints de mesure (m)\n--------------------")
print("\nDans l'air : \nx = ", x_mesure_air*dx)
print("\nDans le milieu : \nx' = ", x_mesure_milieu*dx,"\n")

def animate(n):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    if t_sup < 25*T:
        # Onde venant de la gauche :
        un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 10*T)**2 / (4*T)**2 )
    else:
        # Pour que l'onde parte à l'infini à gauche
        un_sup[0] = un[1]
    
    # Pour que l'onde parte à l'infini à droite
    un_sup[nbx-1] = un[nbx-2] 

    line.set_data(x, un_sup)
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = nbt, interval = 3, repeat = False)
    

print("\n------------------\nParamètres Milieu\n------------------")
print("n = ", n_milieu)
print("Longueur d'onde dans le milieu : lambda = ", lambda_milieu/lambda_0, "lambda0")
print("Largeur : ", largeur_milieu/lambda_0, "lambda_0\n")

# Coefficients de Fresnel
print("\n-----------------------\nCoefficients de Fresnel\n-----------------------")
r = (1 - n_milieu)/(1 + n_milieu) # Négatif si les max deviennent des min
t = (2*1) / (1 + n_milieu)
print("\nInterface air/milieu : r = ", r, " t = ", t)

r = (n_milieu -1)/(1 + n_milieu)
t = (2 * n_milieu) / (1 + n_milieu)
print("Interface milieu/air : r = ", r, " t = ", t, "\n")

print("\n-----------------------\nGrandeurs numériques\n-----------------------")

"""
Calcul des coefficients C1 et C2 tels que :
    k_num = C1/dx
    Vphase_num = C2*c
"""

C1 = 2 * np.arcsin(np.sin(np.pi*S/N_lambda)/S)
C2 = 2 * np.pi/(lambda_0*(C1/dx))
print("\nRésolution spatiale : N_lambda = ", N_lambda)
print("Facteur de stabilité : S = ", S)
print("\nk_numérique = ", C1, "/dx")
print("vPhase_numérique = ", C2, "c\n\n soit\n")

k_num = C1/dx
vph_num = C2*c
N_tr = (np.pi*S)/(2*np.arcsin(S))

print("k_numérique = ", k_num, " Vphase_numérique = ", vph_num)

vph_error = (c-vph_num)/c

print("\nLe rapport des vecteurs k_numérique et k_0 est : k_num/k_0 = ", ((C1/dx) / k_0))
print("L'erreur sur la vitesse de phase est de : ", vph_error*100, " %\n")
print("Résolution spatiale minimum pour avoir k réel : N_transition = ", N_tr)

plt.show()

