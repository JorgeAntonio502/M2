#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*######################
Prototypes des fonctions 
######################*/

// lecture du fichier des paramètres
void read_file (FILE *fp, int *npart, int *ndim, double **pos);

// Calcul de la distance entre deux atomes
double compute_r(double x1, double y1, double z1, double x2, double y2, double z2);

/*#####################
Fonction principale
#####################*/
int main (int argc, char * argv[]) 
{
	printf("\nDébut\n\n");
	
	// Configuration fichiers
	FILE *file, *log;	
	
	file = fopen("config_300K.xyz","r");
	log  = fopen("output.log","w");
	
	// En-tête du fichier de sortie
	fprintf(log,"#%6s	%14s	%14s\n", "distance", "h", "g");
	
	// Indices de boucles
	int i, j;
	
	// Constantes du système
	int n; // nombre de particules
	int ndim; // dimension
	//int nsteps = 1; 
	double T = 300.; // Température
	double L = 24.7; // taille de la boîte
	double rho = 1008/(L*L*L);
	double const factor_norm = (4*M_PI*rho)/3;
	
	// Variables
	double rmax = L/2; // Distance maximale atteignable
	int nk = 1000; // Nombre d'éléments dans g et h
	double dr = rmax/nk; // pas spatial
	int k; // indice pour remplir les h[k]
	
	// Tableau
	double *pos;
	double h[nk]; 
	double g[nk];
	
	// Initialisation h
	for (i = 0; i < nk; i++)
	{
		h[i] = 0;
	}
	
	// Lecture fichier de donnees
	read_file(file, &n, &ndim, &pos);
	
	/*
	for(i = 0; i < n; i++)
	{
		printf("particule n° = %d :	x = %f	y = %f	z = %f\n", i, pos[i*(ndim)], pos[i*(ndim)+1], pos[i*(ndim)+2]);
	}
	*/
	
	// Calcul de l'histogramme h[nk]
	double r;
	
	for(i = 0; i < n-1; i++)
	{
		for(j = i+1; j < n; j++)
		{
			// Calcul de la distance entre les particules
			r = compute_r(pos[i*(ndim)], pos[i*(ndim)+1], pos[i*(ndim)+2], pos[j*(ndim)], pos[j*(ndim)+1], pos[j*(ndim)+2]);
			
			// Calcul de l'indice k
			k = ceil((r/dr));
			
			// Remplissage de h[k]
			if(k <= nk)
			{
				h[k] += 2;
			}
		}	
	}
	
	// Normalisation de h[nk]
	double n_moy; // valeur moyenne des atomes à une distance donnée
	double n_id; // distance donnée dans un gaz parfait
	double r_inf, r_sup;
	
	
	for(i = 1; i < nk; i++)
	{
		// Calcul du nombre moyen à la distance i*dr
		n_moy = h[i]/(nk*1008);
		
		// Calcul des positions sup et inf 
		r_inf = (i-1)*dr;
		r_sup = r_inf + dr;
		
		// Calcul de la distance dans un gaz parfait
		n_id = factor_norm*(pow(r_sup,3) - pow(r_inf, 3));
		
		// Remplissage de g[i]
		g[i] = n_moy/n_id;
	}
	
	
	// Ecriture de h et g dans le fichier de sortie
	for (i = 0; i < nk; i++)
	{
		fprintf(log, "%8f	%14f	%14f\n", i*dr, h[i], g[i]);
	}
	
	printf("\n\nFin\n\n");
	
	return 0;
}



/*#####################
Definitions des fonctions
#####################*/


/* lecture du fichier des paramètres
   Retourne : n, le nombre de particules
   			  ndim, la dimension du problème
   			  pos, le tableau de positions*/
void read_file (FILE *fp, int *npart, int *ndim, double **pos) {

  int i, n, err;
  char a[256];
  double x, y, z;
  
  err = fscanf(fp,"%d",&n);
  *ndim = 3;
  *npart = n;
  *pos = malloc((*ndim)*n*sizeof(double));
  
  for (i=0-2; i<n; i++) {
    err = fscanf(fp, "%s %lf %lf %lf", a, &x, &y, &z);
    (*pos)[i*(*ndim)]   = x;
    (*pos)[i*(*ndim)+1] = y;
    (*pos)[i*(*ndim)+2] = z;
  }
}

// Calcul de la distance entre deux atomes
double compute_r(double x1, double y1, double z1, double x2, double y2, double z2)
{
	return sqrt( (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1) + (z2 - z1)*(z2 - z1) );
}
