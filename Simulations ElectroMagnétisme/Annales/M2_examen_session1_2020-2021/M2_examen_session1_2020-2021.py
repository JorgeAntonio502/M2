# -*- coding: utf-8 -*-
"""
Created on Thu Oct  6 11:42:18 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

"""
# Question b)
"""

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 25
eps_air = 1 
T = lambda_0 / c

# Creation limites figure
fig = plt.figure()
line, = plt.plot([], [])

xmin = 0
xmax = 20*lambda_0
nbx = 200
plt.xlim(xmin, xmax)
plt.ylim(-2, 2)

tmin = 0
tmax = 500
nbt = 300

# Creation tableaux des positons à t-1, t et t+1
un_inf = np.zeros(nbx)
un = np.zeros(nbx)
un_sup = np.zeros(nbx)

# Pas et facteur de stabilité
dx = lambda_0 / N_lambda
S = 1
dt = (S * dx) / c

"""
Calcul des coefficients C1 et C2 tels que :
    k_num = C1/dx
    Vphase_num = C2*c
"""
C1 = 2 * np.arcsin(np.sin(np.pi*S/N_lambda)/S)
C2 = 2*np.pi/(lambda_0*(C1/dx))
print("k_numérique = ", C1, "/dx")
print("vPhase_numérique = ", C2, ".c\n\n soit\n")

v_num = C2*c
print("k_numérique = ", C1/dx, " Vphase_numérique = ", v_num)
print("L'erreur sur la vitesse de phase est de : ", (1-C2)*100, " %")

# Valeurs abscisses et temporelles
x = np.linspace(xmin, xmax, nbx)
t = np.linspace(tmin, tmax, nbt)

# Limites du milieu diaélectrique
lambda_1 = lambda_0/2 # lambda_0/n

lim_min = xmax/2 - 5*lambda_0
lim_max = xmax/2 + 5*lambda_0

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)

print("\n\n", lambda_1)
for i in range(nbx):
    if x[i] > lim_min and x[i] < lim_max:
        eps_r[i] = 2
        
print("\n\n", eps_r)

# Creation limites visuelles du milieu
plt.vlines(lim_min, -2, 2, linestyles ="dashed", colors ="k")    
plt.vlines(lim_max, -2, 2, linestyles ="dashed", colors ="k")

def animate(n):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    t_sup = (n + 1) * dt
    
    if t_sup < 6*T:
        # Onde venant de la droite :
        un_sup[nbx-2] = np.cos((2*np.pi/T)*t_sup) * np.exp(-((t_sup - 6*T)/2*T)**2)
    
        # Onde venant de la gauche :
        un_sup[0] = np.cos((2*np.pi/T)*t_sup) * np.exp(-((t_sup - 8*T)/1.5*T)**2)
    else:
        un_sup[0] = un[1]  # Pour que l'onde parte à l'infini à gauche
        
    
    un_sup[nbx-1] = un[nbx-2]
    
    line.set_data(x, un_sup)
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = t, interval = 3, repeat = False)

plt.show()

"""
# Question e)
"""





