# -*- coding: utf-8 -*-
"""
Created on Wed Oct  5 15:50:40 2022

@author: Utilisateur
"""
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

"""
Exercice 1 : Visualisation
"""

epsilon = np.finfo(float).eps

# La fonction
def f(x, t) :
    return 1 / (1 + (x - 5*t)**2)

# Données d'espace
xmin = -2
xmax = 15
nbx = 171

# Données temporelles
tmin = 0
tmax = 3
nbt = 31

# array d'espace et de temps
x = np.linspace(xmin, xmax, nbx)
time = np.linspace(tmin, tmax, nbt)

# Initialisation de la figure
fig = plt.figure()
line, = plt.plot([], [])

plt.xlim(xmin, xmax)
plt.ylim(-5, 5)

# Animation 
def animate(t):

    y = f(x, t)
    
    line.set_data(x, y)
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = time, repeat =False)

plt.show()


"""
Exercice 2 : Simulation FDTD 1D
"""

# Constantes :
c = 2.99792458e8
lambda_0 = 1.55e-6
N_lambda = 11
eps_air = 1 
T = lambda_0 / c

# Pas et facteur de stabilité
dx = lambda_0 / N_lambda
S = 0.7
dt = (S * dx) / c
print("dx = ", dx, "\ndt = ", dt, "\nS = ", S)

# Création graphe
fig = plt.figure()
line, = plt.plot([], [])

xmin = 0
xmax = 14*lambda_0
nbx = 300
x = np.linspace(xmin, xmax, nbx)

tmin = 0
tmax = 1000*dt
t = np.arange(tmin, tmax, dt)
print("\n\ndurée simulation = ", tmax)

plt.xlim(xmin, xmax)
plt.ylim(-2, 2)

# Tableau des constantes diaéliectriques
eps_r = np.ones(nbx)

# Creation limites visuelles du milieu
#plt.vlines(lim_min, -2, 2, linestyles ="dashed", colors ="k")    
#plt.vlines(lim_max, -2, 2, linestyles ="dashed", colors ="k")

# Creation tableaux des positons à t-1, t et t+1
un_inf = np.zeros(nbx)
un = np.zeros(nbx)
un_sup = np.zeros(nbx)

def animate(t):
    
    for i in range(nbx-1):
        un_sup[i] = ( S**2/eps_r[i] ) * (un[i+1] - 2*un[i] + un[i-1]) + 2*un[i] - un_inf[i]
    
    #t_sup = (n + 1) * dt
    
    # Onde venant de la gauche :
    un_sup[0] = np.cos((2*np.pi/T)*t) * np.exp(-((t - 4.3*T)/1.3*T)**2)
    
        
    
    un_sup[nbx-1] = un[nbx-2]
    
    line.set_data(x, un_sup)
    
    un_inf[:] = un[:]
    un[:] = un_sup[:]
    
    return line,

ani = animation.FuncAnimation(fig, func = animate, frames = t, interval = 3, repeat = False)

plt.show()
