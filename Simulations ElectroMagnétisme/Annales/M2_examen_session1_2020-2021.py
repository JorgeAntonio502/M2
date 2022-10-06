# -*- coding: utf-8 -*-
"""
Created on Thu Oct  6 11:42:18 2022

@author: Utilisateur
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

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
xmax = 15*lambda_0
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

# Limites du milieu

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)

# Pas et facteur de stabilité
dx = lambda_0 / 8
S = 1
dt = (S * dx) / c

tc = 30*dt
tau = 10*dt

# Valeurs abscisses et temporelles
x = np.linspace(xmin, xmax, nbx)
t = np.linspace(tmin, tmax, nbt)

def animate(n):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    t_sup = (n + 1) * dt
    
    # Onde venant de la gauche :
    un_sup[0] = np.exp( -( (t_sup-tc)/tau)**2 )
    
    # Onde venant de la droite :
    un_sup[nbx-1] = np.cos((2*np.pi/T)*t_sup) * np.exp(-((t_sup - 3*T)/T)**2)
    
        
    #un_sup[nbx-1] = un[nbx-2]
    
    line.set_data(x, un_sup)
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, interval = 3, repeat = False)

plt.show()