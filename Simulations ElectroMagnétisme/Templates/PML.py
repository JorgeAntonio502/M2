import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constantes :
c = 2.99792458e8
lambda0 = 1.55e-6
N_lambda = 20
mu0 = np.pi*4e-7 # SI
eps0 = 1/(mu0*c**2) # SI
T = lambda0 / c # T de source dans le vide de longueur d'onde lambda_0

# Pas et facteur de stabilité
dx = lambda0 / N_lambda
S = 1
dt = (S * dx) / c

# Nombre de valeurs pour les champs Ez et Hz
nbEz = 30 * N_lambda # Choix arbitraire
nbHy = nbEz - 1 # Toujours nb_E - 1

# Largeur du domaine de simulation
xmin = 0 
xmax = (nbEz-1) * dx

# Tableaux pour stockage des valeurs de Ez et Hz
Ez = np.zeros(nbEz)   # Champ Ez
Hy = np.zeros(nbHy) # Champ Hy

# Positions de calcul de Ez et Hz
xEz = np.linspace(xmin, xmax, nbEz)
xHy = np.linspace(xmin+dx/2, xmax-dx/2, nbHy)

# indice du milieu 2
indice2 = 2 # Choix arbitraire

# définition du tableau pour les indices de refraction
indice = np.ones(nbEz)
for i in range(nbEz):
    if xEz[i] > 15*lambda0:
        indice[i] = indice2

# définition des tableaux pour epsilon et mu (valeurs générales)
eps = eps0 * indice**2
mu = mu0 * np.ones(nbHy)

# construction du milieu pml
debut_pml = 25 * lambda0

    # Permittivité et perméabilité relatives :
eps_r_pml = indice2 **2   # cas de pml dans le milieu 2
mu_r_pml = 1    

    # Permittivité et perméabilité absolue
eps_pml = eps0 * eps_r_pml
mu_pml  =  mu0 *  mu_r_pml

    # Impédance de la PML
eta_pml = np.sqrt( mu_pml/ eps_pml )

# application de la formule 7.60a : sigma_x = (x/d)**m * sigma_x_max

m = 3    # l'usage est d'avoir 3 <= m <=4 (voir au-dessus de la formule 7.62)
d = 10*dx # largeur de la PML (à adapter pour qu'il n'y ait pas de réflexions)

# définition de sigma_x_max avec la formule 7.66 qui correspond à 10 couches
sigma_x_max = 0.8 * (m+1) / ( eta_pml * dx )



# definition de sigma_x une fois entré dans PML (règle empirique du livre)
def sigma_x(x):
    return (x/d)**m * sigma_x_max

sig = np.zeros(nbEz)
for i in range(nbEz):
    if xEz[i] > debut_pml:
        sig[i] = sigma_x(xEz[i]-debut_pml)

sim = np.zeros(nbHy) # sigma_étoile
for i in range(nbHy):
    if xHy[i] > debut_pml:
        sim[i] = sigma_x(xHy[i]-debut_pml) * mu_pml / eps_pml

ca = (1-sig*dt/(2*eps)) / (1+sig*dt/(2*eps))
cb = dt/(dx*eps) / (1+sig*dt/(2*eps))  
da = (1-sim*dt/(2*mu)) / (1+sim*dt/(2*mu))
db = dt/(dx*mu) / (1+sim*dt/(2*mu))  

# Nombre d'instants
nbt = int(10 * (xmax/lambda0) * T / dt)

# Initialisation de la figure
fig = plt.figure() 
plt.plot(xEz, indice) 
line, = plt.plot(xEz, Ez)
plt.ylim(-1.5, 2.1)

def animate(n):
    
    # Calcul de l'instant
    t_sup = (n + 1) * dt
    
    # champ de la source
    Ez[0] = np.cos( (2*np.pi/T * t_sup) ) * np.exp( -(t_sup - 8.2*T)**2 / (3.2*T)**2 )
    
    # calcul du champ avec le schema numerique
    for i in range(1, nbEz-1):
        Ez[i] = cb[i] * (Hy[i]-Hy[i-1]) + ca[i] * Ez[i]
    for i in range(nbHy):
        Hy[i] = db[i] * (Ez[i+1]-Ez[i]) + da[i] * Hy[i]
        
    line.set_data(xEz, Ez)
    
    return line,
 
ani = animation.FuncAnimation(fig, animate, frames=nbt, blit=True, interval=1, repeat=False)

plt.show()

