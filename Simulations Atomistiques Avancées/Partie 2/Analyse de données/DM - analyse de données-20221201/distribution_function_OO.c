#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*######################
Prototypes des fonctions 
######################*/

// lecture du fichier des paramètres
void read_file (FILE *fp, int *ndim, double **pos);

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
	
	file = fopen("config_3500K.xyz","r");
	log  = fopen("output.log","w");
	
	// En-tête du fichier de sortie
	fprintf(log,"#%6s	%14s	%14s\n", "distance", "h", "g");
	
	// Indices de boucles
	int i, j;
	
	// Constantes du système
	int ndim; // dimension
	double N_O = 672; // Nompbre d'atomes d'oxygène
	double N_Si = 336; // Nombre d'atomes de Silice
	double N = N_O + N_Si; // Nombre total d'atomes
	double T = 300.; // Température
	double L = 24.7; // taille de la boîte
	double rho = 1008/(L*L*L);
	double const factor_norm = (L*L*L)/(4*M_PI*N_O*(N_O - 1));
	
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
	read_file(file, &ndim, &pos);
	
	/*
	for(i = 0; i < n; i++)
	{
		printf("particule n° = %d :	x = %f	y = %f	z = %f\n", i, pos[i*(ndim)], pos[i*(ndim)+1], pos[i*(ndim)+2]);
	}
	*/
	
	// Calcul de l'histogramme h[nk]
	double dx, dy, dz, r;
	
	for(i = 0; i < N_O; i++)
	{
		for(j = 0; j < N_O; j++)
		{
			// Calcul de la distance entre les particules
			//r = compute_r(pos[i*(ndim)], pos[i*(ndim)+1], pos[i*(ndim)+2], pos[j*(ndim)], pos[j*(ndim)+1], pos[j*(ndim)+2]);
			
			// Calcul différences des coordonnées
			dx = pos[i*(ndim)] - pos[j*(ndim)];
			dy = pos[i*(ndim)+1] - pos[j*(ndim)+1];
			dz = pos[i*(ndim)+2] - pos[j*(ndim)+2];
			
			// PBC
			dx = dx - round(dx/L) * L;
			dy = dy - round(dy/L) * L;
			dz = dz - round(dz/L) * L;
			
			// Calcul distnace entre i et j
			r = sqrt(dx*dx + dy*dy + dz*dz);
			
			// Calcul de l'indice k
			k = ceil((r/dr));
			
			// Remplissage de h[k]
			if(k <= nk)
			{
				h[k] += 1;
			}
		}	
	}
	
	// Normalisation de h[nk]
	double Vdr;
	
	for(i = 1; i < nk; i++)
	{
		r = dr*i;
		Vdr = (dr*r*r);
		// Remplissage de g[i]
		g[i] = h[i]*factor_norm / Vdr;
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
void read_file (FILE *fp, int *ndim, double **pos) {

  int i, n, err;
  char a[256];
  double x, y, z;
  
  err = fscanf(fp,"%d",&n);
  *ndim = 3;
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
