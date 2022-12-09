#include <stdlib.h>
#include <stdio.h>
#include <math.h>

/*#####################
Fonction principale
#####################*/
int main (int argc, char * argv[]) 
{
	printf("\nDébut\n\n");
	
	// Configuration fichiers
	FILE *file, *log;	
	
	file = fopen("pos-3500K.xyz","r");
	log  = fopen("output.log","w");
	
	// Détection d'erreurs d'ouvertures
 	if(file == NULL)
 	{
 		printf("Error reading input file\n");
 		return 1; 
 	}
 	
 	if(log == NULL)
 	{
 		printf("Error reading input file\n");
 		return 1; 
 	}
 	
	// Ecriture en-têtes des colonnes dans le fichier de sortie
 	fprintf(log, "#n\th\tg\n");
	
	
	// Indices de boucles
	int i, j, num_it;
	
	// Infomaions fichiers
	int nb_config = 101;
	
	// Constantes du système
	double N_O = 672; // Nombre d'atomes d'oxygène
	double N_Si = 336; // Nombre d'atomes de Silice
	double N = N_O + N_Si; // Nombre total d'atomes
	double L = 24.7; // taille de la boîte * rayon de bohr
	
	double const factor_norm = ( (L*L*L)/(4*M_PI*N_O*(N_O-1)) )/nb_config;
	
	// Variables
	double rmax = L/2; // Distance maximale atteignable
	int nk = 1000; // Nombre d'éléments dans g et h
	double dr = rmax/nk; // pas spatial
	int k; // indice pour remplir les h[k]
	
	// Tableaux des coordonnées
	char Type;
 	double x[1008*nb_config]; 
 	double y[1008*nb_config];
 	double z[1008*nb_config];
 	
 	// Tableaux de h et g
	float h[nk];
	float g[nk];
	
	// Initialisation h
	for (i = 0; i < nk; i++)
	{
		h[i] = 0;
	}
 	
 	// Lecture fichier
	int read = 0; // Compte le nombre de valeurs correctement lues par ligne
	int cpt = 0; // Compte le nombre de lignes correctement lues
	 	
	do
	{
		read = fscanf(file, "%c\t%lf\t%lf\t%lf",
		              &Type, &x[cpt], &y[cpt], &z[cpt]);
	 		              
		if(read == 4)
		{
			//printf("%f, %f, %f\n", x[cpt], y[cpt], z[cpt]);
			cpt += 1;
		}
	 		              
	}while(!feof(file));
	
	// Calcul de l'histogramme h[nk]
		double dx, dy, dz, r;
	
	// Boucle sur le nombre de configurations
	for (num_it = 0; num_it < nb_config; num_it++)
	{		
		for(i = num_it*N; i < num_it*N + N_O; i++)
		{
			for(j = num_it*N; j < num_it*N + N_O; j++)
			{
				// Calcul différences des coordonnées
				dx = x[i] - x[j];
				dy = y[i] - y[j];
				dz = z[i] - z[j];
				
				// PBC
				dx = dx - round(dx/L) * L;
				dy = dy - round(dy/L) * L;
				dz = dz - round(dz/L) * L;
				
				// Calcul distance entre i et j
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
