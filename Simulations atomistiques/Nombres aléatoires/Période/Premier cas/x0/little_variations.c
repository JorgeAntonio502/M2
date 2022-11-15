#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

float LC_RNG(int k, int l, int m, int x_n);

int main()
{
	// Fichier contenant les donnees
	FILE *fp;
	
    fp = fopen("x0_variations.txt", "w");

    if (fp == NULL) {
		printf("File error\n");
		exit(1);
	}
	
	// Parametres du generateur
	int k = 899;
	int l = 0;
	int m = 32768;
	
	// Nombre de valeurs generees (au moins 10 periodes)
	long int N = 10*m;
	
	// Valeur de la periode
	int periode = 0;
	
	// Variable contenant r de reference
	float r_reff = 0;
	
	// Variations de la variables
	int variation = 25;
	
	// Début de generations de nombres
	printf("Début\n\n");
	
	for (int var = -variation; var < variation + 1; var++)
	{
		int x_0 = 12 + var;
		int x_n = x_0;
		
		for (int i = 0; i < N; i++)
		{
			// Appel du generateur
			float x = LC_RNG(k, l, m, x_n);
			
			// Calcul du nombre aleatoire genere
			float r = x/m;
			
			// Condition pour la reference
			if (i == 0)
			{
				r_reff = r;
				//printf("r_reff = %f\n", r_reff);
			}
			
			// Condition pour periode
			if (i != 0 && r == r_reff)
			{
				//printf("k = %d | Période = %d\n\n", k+var, i);
				
				// Ecriture de k et de la période dans le fichier
				fprintf(fp, "%d %d\n", x_0, i);
				break;
			}
			
			// MAj de x_n
			x_n = x;
		}
	}
	
	// Fermeture fichiers
	fclose(fp);
	
	printf("\nFin\n\n");

	return 0;
}

float LC_RNG(int k, int l, int m, int x_n)
{
	return (k*x_n + l) % m;
}
