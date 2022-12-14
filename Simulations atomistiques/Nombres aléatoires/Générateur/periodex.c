#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

long double LC_RNG(long int k, long int l, long int m, long int x_n);

int main()
{
	// Fichier contenant les donnees
	FILE *fp;
    fp = fopen("random_numbers.txt", "w");

    if (fp == NULL) {
		printf("File error\n");
		exit(1);
	}
	
	// Parametres du generateur
	long int k = pow(7, 5);
	int l = 0;
	long int m = pow(2, 31) - 1;
	long int x_n = 12;
	
	// Nombre de valeurs generees (au moins 10 periodes)
	long int N = m;
	
	// Compteur de répétitions
	int cpt = 1;
	int periode = 0;
	
	// Variable contenant r de reference
	long int x_reff = 0;
	
	// Début de generations de nombres
	printf("Début\n\n");
	
	for (int i = 0; i < N; i++)
	{
		// Appel du generateur
		float x = LC_RNG(k, l, m, x_n);
		
		// Calcul du nombre aleatoire genere
		//float r = x/m;
		
		// Condition pour la reference
		if (i == 0)
		{
			x_reff = x;
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
		
		// Ecriture de r dans le fichier
		//fprintf(fp, "%d %f\n", i+1, x);
		
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
