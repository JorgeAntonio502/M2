# -*- coding: utf-8 -*-
"""
Created on Sat Dec  3 17:04:43 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 34
mu0 = np.pi*4e-7 # SI
eps0 = 1/(mu0*c**2) # SI
T = lambda_0 / c # T de source dans le vide de longueur d'onde lambda_0

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
Paramètrage du milieu transparent d'indice n
"""

# Paramètres milieu transparent
n_milieu = 2.2
lambda_milieu = lambda_0/n_milieu
largeur_milieu = 9.6*lambda_0

debut_milieu = L/2 - largeur_milieu/2
fin_milieu = L/2 + largeur_milieu/2
        
# Tableau des constantes diaéliectriques
eps_r = np.ones(nbEz)
for i in range(nbEz):
    if(xEz[i] >= debut_milieu and xEz[i]  <= fin_milieu):
        eps_r[i] = n_milieu**2

# définition des tableaux pour epsilon et mu
eps = eps0 * eps_r
mu = mu0 * np.ones(nbHy)

"""
Paramètrage de la PML
"""

# construction du milieu pml
debut_pml = nbEz # Valeur max de x pour pas de PML

    # Permittivité et perméabilité relatives :
eps_r_pml = n_milieu**2   # cas de pml dans le milieu 2
mu_r_pml = 1    

    # Permittivité et perméabilité absolue
eps_pml = eps0 * eps_r_pml
mu_pml  =  mu0 *  mu_r_pml

    # Impédance de la PML
eta_pml = np.sqrt( mu_pml/ eps_pml )

"""
Paramètrage sigma (Ez) et sigma_étoile (Hz) à l'intérieur de la PML
"""

# application de la formule 7.60a : sigma_x = (x/d)**m * sigma_x_max

m = 3    # l'usage est d'avoir 3 <= m <=4 (voir au-dessus de la formule 7.62)
d = 10*dx # largeur de la PML (à adapter pour qu'il n'y ait pas de réflexions)

# définition de sigma_x_max avec la formule 7.66 qui correspond à 10 couches
sigma_x_max = 0.8 * (m+1) / ( eta_pml * dx )

# definition de sigma_x une fois entré dans PML (règle empirique du livre)
def sigma_x(x):
    return (x/d)**m * sigma_x_max

# sigma
sig = np.zeros(nbEz) 
for i in range(nbEz):
    if xEz[i] > debut_pml:
        sig[i] = sigma_x(xEz[i]-debut_pml)

# sigma_étoile        
sim = np.zeros(nbHy) 
for i in range(nbHy):
    if xHy[i] > debut_pml:
        sim[i] = sigma_x(xHy[i]-debut_pml) * mu_pml / eps_pml

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
    
    if t_sup < 20*T:
        # champ de la source
        Ez[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 8.2*T)**2 / (3.2*T)**2 )
    else:
        # Pour que l'onde parte à l'infini à gauche
        Ez[0] = Ez[1]
    
    # calcul du champ avec le schema numerique
    for i in range(1, nbEz-1):
        Ez[i] = cb[i] * (Hy[i]-Hy[i-1]) + ca[i] * Ez[i]
    for i in range(nbHy):
        Hy[i] = db[i] * (Ez[i+1]-Ez[i]) + da[i] * Hy[i]
    
    # Pour que l'onde parte à l'infini à droite
    Ez[nbEz-1] = Ez[nbEz-2]
        
    line.set_data(xEz, Ez)
    
    return line,
 
ani = animation.FuncAnimation(fig, animate, frames=nbt, blit=True, interval=1, repeat=False)

# Coefficients de Fresnel
print("\n-----------------------\nCoefficients de Fresnel\n-----------------------")
r = (1 - n_milieu)/(1 + n_milieu) # Négatif si les max deviennent des min
t = (2*1) / (1 + n_milieu)
print("\nInterface air/milieu : r = ", r, " t = ", t)

r = (n_milieu -1)/(1 + n_milieu)
t = (2 * n_milieu) / (1 + n_milieu)
print("Interface milieu/air : r = ", r, " t = ", t, "\n")

"""
Calcul des coefficients C1 et C2 tels que :
    k_num = C1/dx
    Vphase_num = C2*c
"""

print("\n--------------------\nGrandeurs numériques\n--------------------")

C1 = 2 * np.arcsin(np.sin(np.pi*S/N_lambda)/S)
C2 = 2 * np.pi/(lambda_0*(C1/dx))
print("k_numérique = ", C1, "/dx")
print("vPhase_numérique = ", C2, ".c\n\n soit\n")

print("k_numérique = ", C1/dx, " Vphase_numérique = ", C2*c)
print("L'erreur sur la vitesse de phase est de : ", (1-C2)*100, " %")

plt.show()