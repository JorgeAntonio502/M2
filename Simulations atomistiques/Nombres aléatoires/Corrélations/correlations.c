#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

long double LC_RNG(long int k, long int l, long int m, long int x_n);

int main()
{
	// Fichier contenant les donnees
	FILE *fp;
    fp = fopen("correlations.txt", "w");

    if (fp == NULL) {
		printf("File error\n");
		exit(1);
	}
	
	// Parametres du generateur
	long int k = pow(7, 5);
	int l = 0;
	long int m = pow(2, 31) - 1;
	int x_n = 12;
	
	// Variable contenant le dernier nombre genere
	float x_inf;
	
	// Nombre de valeurs generees
	long int N = 10e4;
	
	// Compteur de répétitions
	int cpt = 1;
	int periode = 0;
	
	// Variable contenant r de reference
	float x_reff = 0;
	
	// Début de generations de nombres
	printf("Début\n\n");
	
	for (int i = 0; i < N; i++)
	{
		// Appel du generateur
		float x = LC_RNG(k, l, m, x_n);
		
		// Calcul du nombre aleatoire genere
		//float r = x/m;
		
		// Ecriture de r_inf et de r dans le fichier
		if (i != 0)
		{
			fprintf(fp, "%f %f\n", x_inf, x);
		}
		
		// Enregistrement du nombre genere
		x_inf = x;
		
		// Condition pour la reference
		if (i == 0)
		{
			x_reff = x;
			printf("Premier nombre généré : %f\n", x);
		}
		
		// Condition pour periode
		if (i != 0 && x == x_reff)
		{
			printf("Répétition n°= %d | Position n°= %d\n\n", cpt, i);
			
			if(cpt == 1)
			{
				periode = i;
			}
			cpt += 1;
			
		}
		
		// MAj de x_n
		x_n = x;
	}
	
	// Fermeture fichier
	fclose(fp); 
	
	printf("\nPériode : %d\n\n", periode);
	
	printf("\nFin\n\n");

	return 0;
}

long double LC_RNG(long int k, long int l, long int m, long int x_n)
{
	return (k*x_n + l) % m;
}
