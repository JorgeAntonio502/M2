# -*- coding: utf-8 -*-
"""
Nom : Chopin
Prenom : Antonio
Exercice : 1l
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 31
mu0 = np.pi*4e-7 # SI
eps0 = 1/(mu0*c**2) # SI
T = lambda_0 / c # T de source dans le vide de longueur d'onde lambda_0
k_0 = (2*np.pi)/(T*c)

# Pas et facteur de stabilité
dx = lambda_0 / N_lambda
S = 1
dt = (S * dx) / c

"""
Paramètrage des champs Ez et Hz
"""

# Nombre de valeurs pour les champs Ez et Hz
nbEz = 30 * N_lambda # Choix arbitraire
nbHy = nbEz - 1 # Toujours nb_E - 1

# Largeur du domaine de simulation
xmin = 0 
xmax = (nbEz-1) * dx
L = xmax - xmin

# Nombre d'instants
nbt = int(10 * (xmax/lambda_0) * T / dt)

# Tableaux pour stockage des valeurs de Ez et Hz
Ez = np.zeros(nbEz)   # Champ Ez
Hy = np.zeros(nbHy) # Champ Hy

# Positions de calcul de Ez et Hz
xEz = np.linspace(xmin, xmax, nbEz)
xHy = np.linspace(xmin+dx/2, xmax-dx/2, nbHy)

"""
Paramètrage du milieu de conductivité sigma
"""

# Paramètres milieu conducteur
sigma_milieu = 3000
largeur_milieu = 7*lambda_0

debut_milieu = L/2 - largeur_milieu/2
fin_milieu = L/2 + largeur_milieu/2
        
# Tableau des constantes diaéliectriques
eps_r = np.ones(nbEz)

# définition des tableaux pour epsilon et mu
eps = eps0 * eps_r
mu = mu0 * np.ones(nbHy)

"""
Paramètrage sigma (Ez) et sigma_étoile (Hz) à l'intérieur du milieu conducteur
"""

# sigma
sig = np.zeros(nbEz) 
for i in range(nbEz):
    if xEz[i] > debut_milieu and xEz[i] < fin_milieu:
        sig[i] = sigma_milieu

# sigma_étoile        
sim = np.zeros(nbHy) 
for i in range(nbHy):
    if xHy[i] > debut_milieu and xHy[i] < fin_milieu:
        sim[i] = sigma_milieu

"""
Coefficients pour calcul successifs de Ez et Hz
"""

ca = (1-sig*dt/(2*eps)) / (1+sig*dt/(2*eps))
cb = dt/(dx*eps) / (1+sig*dt/(2*eps))  
da = (1-sim*dt/(2*mu)) / (1+sim*dt/(2*mu))
db = dt/(dx*mu) / (1+sim*dt/(2*mu))  


# Initialisation de la figure
fig = plt.figure() 
line, = plt.plot(xEz, Ez)
plt.ylim(-2, 2)

# Limites visuelles du milieu
plt.vlines(debut_milieu, -2, 2, colors='k', linestyle='dashed')
plt.vlines(fin_milieu, -2, 2, colors='k', linestyle='dashed')

def animate(n):
    
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    # champ de la source
    Ez[0] = np.cos( 2*np.pi/T * (t_sup - 7*T ) )* np.exp( -(t_sup - 7*T)**2 / (2.5*T)**2 )
    
    # calcul du champ avec le schema numerique
    for i in range(1, nbEz-1):
        Ez[i] = cb[i] * (Hy[i]-Hy[i-1]) + ca[i] * Ez[i]
    for i in range(nbHy):
        Hy[i] = db[i] * (Ez[i+1]-Ez[i]) + da[i] * Hy[i]
        
    line.set_data(xEz, Ez)
    
    return line,
 
ani = animation.FuncAnimation(fig, animate, frames=nbt, blit=True, interval=1, repeat=False)

print("\n-----------------------------\nParamètres Milieu conducteur\n-----------------------------")

delta = np.sqrt( T/(np.pi*mu0*sigma_milieu))
                
print("conductivité : epsilon = ", sigma_milieu)
print("Largeur : ", largeur_milieu/lambda_0, "lambda_0")
print("Epaisseur de peau : delta = sqrt( T/(np.pi*mu_0*sigma_milieu) ) ) =", delta/lambda_0 , "lambda_0")

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



