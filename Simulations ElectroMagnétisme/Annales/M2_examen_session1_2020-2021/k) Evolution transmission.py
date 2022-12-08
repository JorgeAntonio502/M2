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
N_lambda = 25
eps_air = 1 
T = lambda_0 / c
k_0 = (2*np.pi)/(T*c)

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

# Paramètres du milieu transparent
n_milieu = 2
lambda_milieu = lambda_0/n_milieu

# Paramètres couches transparentes
nb_couches = 10
largeur_couches = lambda_milieu/4   # Epaisseur d'une couche
largeur_air = lambda_0/4            # intervalle d'air entre chaque couche

# point de référence pour création de nouvelles couches (Variable)
x_ref = L/2
fin_couches = L/2

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)

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

# Variables pour mesure du ratio des ondes tranmises
E_ref1 = 0 # Le max de l'absolu de l'onde avant les couches
E_ref2 = 0 # Le max de l'absolu de l'onde après les couches

x_mesure1 = int(nbx/30) # Premier point de mesure (fixé)
x_mesure2 = 0 # Second point de mesure (variable)

# Tableaux pour stocker les valeurs (nombre de couches et ratio des amplitudes)
NB = []
Ratio = []
Ratio_log = []

print("\nDébut simulation\n")

# Boucle sur les N couches
for j in range(0, nb_couches):
    
    print("\nCas n = ", j, " couches")
    
    # Variation de la fin des couches
    #if j == 0 :
    #    pass
    if j == 0 :
        fin_couches = x_ref + largeur_couches
    else :
        fin_couches = x_ref + (largeur_air + largeur_couches)
        
    # Modification du tableau des epsilon_r
    for i in range(nbx):
        if(x[i] >= (x_ref + largeur_air) and x[i]  <= fin_couches):
            eps_r[i] = n_milieu**2
    
    # Mise à jour du point de référence
    x_ref = fin_couches
    
    # Mise à jour du point de mesure après les couches
    x_mesure2 = int(fin_couches/dx + nbx/30)
    
    # Boucle temporelle principale
    for n in range(nbt):
        
        for i in range(nbx-1):
            un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
        
        # Calcul de l'instant
        t_sup = (n + 1) * dt
        
        # Détection du maximum avant les couches
        if abs(un_sup[x_mesure1]) > E_ref1 :
            E_ref1 = abs(un_sup[x_mesure1])
            
            
        # Détection du maximum après les couches
        if abs(un_sup[x_mesure2]) > E_ref2 :
            E_ref2 = abs(un_sup[x_mesure2]) 
            
        # Suppression des réflexions
        if t_sup < 25*T:
            # Onde venant de la gauche :
            un_sup[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 10*T)**2 / (4*T)**2 )
        else:
            # Pour que l'onde parte à l'infini à gauche
            un_sup[0] = un[1]
        
        # Pour que l'onde parte à l'infini à droite
        un_sup[nbx-1] = un[nbx-2] 
        
        un_inf[:] = un[:]
        un[:] = un_sup[:]
    
    
    # Affichage des amplitudes de référence trouvées
    print(" E_max1 = ", E_ref1)
    print(" E_max2 = ", E_ref2)
    
    # Remplissage tableaux
    NB.append(j)
    Ratio.append(E_ref2/E_ref1)
    Ratio_log.append(np.log(E_ref2/E_ref1))
    
    # Remise à zero des Amplitudes de référence
    E_ref1 = 0
    E_ref2 = 0
    
    # Remise à zero des tableaux
    un_inf = np.zeros(nbx)
    un = np.zeros(nbx)
    un_sup = np.zeros(nbx)
    

print("Fin simulation\n\n")

plt.plot(NB, Ratio)
plt.xlabel("Number of layers")
plt.ylabel("E_trans/E_inc")
plt.title("Evolution of Tranmission with the number of layers")
plt.show()


plt.plot(NB, Ratio_log)
plt.xlabel("Number of layers")
plt.ylabel("Ln(E_trans/E_inc)")
plt.title("Logarithmic evolution of Tranmission with the number of layers")
plt.show()
