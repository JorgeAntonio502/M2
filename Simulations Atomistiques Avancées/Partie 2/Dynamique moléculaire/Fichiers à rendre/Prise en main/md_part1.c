/* Simple (and inefficient!) molecular dynamics code for a Lennard-Jones system. */
/* The code is only meant for pedagogical purposes, not for production. */
/* Author: Daniele Coslovich (daniele.coslovich@umontpellier.fr) */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*Evaluates the quadratic radius*/
double quadratic_radius(int ndim, int n, double r[], double Rx)
{
  int i, j;
  double Rg = 0;
	
  for (j=0; j<n; j++) {
    for (i=0; i<ndim; i++) {
      Rg += (r[j*ndim+i] - Rx)*(r[j*ndim+i] - Rx);
    }
  }
  
  return sqrt(Rg/n);
}

/* Evaluates the center of mass of the nano-particle */
double Center_of_mass (int ndim, int n, double r[]) {
  int i, j;
  double Rx = 0.0;
  
  for (j=0; j<n; j++) {
    for (i=0; i<ndim; i++) {
      Rx += r[j*ndim+i];
    }
  }
  
  return Rx/n;
  
}

/* Evaluate the potential energy and the virial contribution  */
/* using the cut and shifted Lennard-Jones potential */
void potential (double rcut, double rsq, double *u, double *w) {
  double uc;
  double r6, r12;
  r6 = rsq * rsq * rsq;
  r12 = r6 * r6;
  uc = 4.0/pow(rcut,12) - 4.0/pow(rcut,6);
  *u = 4.0 * (1.0/r12 - 1.0/r6) - uc;
  *w = 24.0 * (2.0/r12 - 1.0/r6) / rsq;
}

/* Apply minimum image convention to a distance vector r. */
/* This function can also be used to fold a particle back  */
/* in the central cell during a simulation. However, it won't */
/* correctly fold back a particle from an arbitrary position. */
void pbc (int n, double r[], double box[]) {
  int i;
  for (i=0; i<n; ++i) {
    if (r[i] > box[i]/2.0) {
      r[i] -= box[i];
    }
    else if (r[i] < -box[i]/2.0) {
      r[i] += box[i];
    }
  }
}

/* Evaluate the kinetic energy from the particles' velocities */
double kinetic (int ndim, int n, double vel[]) {
  int i, j;
  double ekin = 0.0;
  for (j=0; j<n; j++) {
    for (i=0; i<ndim; i++) {
      ekin += pow(vel[j*ndim+i],2);
    }
  }
  ekin *= 0.5;
  return ekin;
}

/* Evaluate the potential energy and the forces between particles */
void forces (int ndim, int n, double rcut, double box[], double pos[],
		double forc[], double *epot) {
  double rij[ndim], rijsq, uij, wij;
  int i, j, k;
  *epot = 0.0;
  for (i=0; i<n*ndim; i++) 
    forc[i] = 0.0;
  for (i=0; i<n; i++) {
    for (j=i+1; j<n; j++) {
      for (k=0; k<ndim; k++) 
	rij[k] = pos[ndim*i+k] - pos[ndim*j+k];
      pbc(ndim, rij, box);
      rijsq = 0.0;
      for (k=0; k<ndim; k++) 
	rijsq += pow(rij[k],2);
      if (rijsq < pow(rcut,2)) {
	potential(rcut, rijsq, &uij, &wij);
	*epot += uij;
	for (k=0; k<ndim; k++) {
	  forc[i*ndim+k] += wij * rij[k];
	  forc[j*ndim+k] -= wij * rij[k];
	}
      }
    }
  }
}

/* Integration step using the velocity-Verlet algorithm */
void evolve (int ndim, int n, double dt, double rcut, double box[],
		double pos[], double vel[], double forc[], double *epot) {
  int i, j, k;
  double mass = 1.0;
  
  for (i=0; i<n; i++)
    for (k=0; k<ndim; k++) {
      pos[i*ndim+k] += vel[i*ndim+k] * dt + 0.5 * forc[i*ndim+k] / mass * pow(dt,2);
      vel[i*ndim+k] += 0.5 * forc[i*ndim+k] / mass * dt;
    }
  for (i=0; i<n; i++)
    pbc(ndim, &(pos[i*ndim]), box);

  forces(ndim, n, rcut, box, pos, forc, epot);

  for (i=0; i<n; i++) 
    for (k=0; k<ndim; k++) 
      vel[i*ndim+k] += 0.5 * forc[i*ndim+k] / mass * dt;
}

/* Read a configuration in xyz format from file. */
/* Positions and velocities are stored in 1d arrays */
/* Return: box size, positions and velocities of particles */
void read_file (FILE *fp, int *npart, int *ndim, double **box, double **pos, double **vel) {
  int i, n, err;
  char a[256], b[256];
  double x, y, z, vx, vy, vz;
  err = fscanf(fp,"%d",&n);
  err = fscanf(fp, "%lf %lf %lf", &x, &y, &z);
  *ndim = 3;
  *npart = n;
  *pos = malloc((*ndim)*n*sizeof(double));
  *vel = malloc((*ndim)*n*sizeof(double));
  *box = malloc((*ndim)*sizeof(double));
  (*box)[0] = x;
  (*box)[1] = y;
  (*box)[2] = z;
  for (i=0; i<n; i++) {
    err = fscanf(fp, "%s %lf %lf %lf %lf %lf %lf", a, &x, &y, &z, &vx, &vy, &vz);
    (*pos)[i*(*ndim)]   = x;
    (*pos)[i*(*ndim)+1] = y;
    (*pos)[i*(*ndim)+2] = z;
    (*vel)[i*(*ndim)]   = vx;
    (*vel)[i*(*ndim)+1] = vy;
    (*vel)[i*(*ndim)+2] = vz;
  }
}

/* Dump some thermodynamic quantities to file */
void report (int what, FILE *fp, int ndim, int n, int steps, double pos[], double vel[], double epot, double Rx, double Rg) {
  double ekin;
  
  // Creation des en-tetes des colonnes du fichier avant le debut de la simulation 
  if (what == 0) {
    fprintf(fp,"# %6s %14s %14s %14s %14s %14s %14s\n","Steps", "Rx", "Rg", "Epot", "Temp", "Ekin", "Etot");
  }
  
  // Ecriture des donnees tous les dix pas
  else if (what == 1) {
    ekin = kinetic(ndim, n, vel);
    fprintf(fp, "%8d %14f %14f %14f %14f %14f %14f\n", steps, Rx, Rg, epot, 2.0*ekin/(n*ndim), ekin, epot+ekin);
  }
}

int main (int argc, char * argv[]) {

  // Parametres et tableaux de donnees
  int i, n, k, ndim, nsteps = 1000;
  double *box, dt = 0.002, rc = 2.5, epot;
  double *pos, *vel, *forc;
  
  // Ajout de la variable pour la coordonnee x du centre de masse
  double Rx = 0.0;
  
  // Ajout variablr pour rayon quadratique moyen
  double Rg = 0.0;
  
  // Configuration fichiers
  FILE *file, *log;

  file = fopen("nano_A.xyz","r");
  log  = fopen("output.log","w");
  /* Read input configuration and allocate arrays */
  read_file(file, &n, &ndim, &box, &pos, &vel);
  forc = malloc(n*ndim*sizeof(*forc));
  forces(ndim,n,rc,box,pos,forc,&epot);
  
  // Ecriture des colonnes du fichier de donnees
  report(0,log,ndim,n,0,pos,vel,epot,Rx,Rg);
  
  /* Main MD loop */
  for (i=0; i<nsteps; i++) {
  
  	// Evolution du systeme 
    evolve(ndim,n,dt,rc,box,pos,vel,forc,&epot);
    
    // Calcul du centre de masse avec les nouvelles positions
    Rx = Center_of_mass(ndim, n, pos);
    
    // Calcul du rayon quadratique
    Rg = quadratic_radius(ndim, n, pos, Rx);
    
    // Ecriture des donnees dans le fichier
    if (i % 10 == 0) report(1,log,ndim,n,i,pos,vel,epot,Rx,Rg);
  }
  fclose(file);
  fclose(log);
}
