#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

float LC_RNG(int k, int l, int m, int x_n);

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
	int k = pow(7, 5); // P2 : 16768
	int l = 0;
	int m = pow(2, 31) - 1; // P1 : {32760, 32783}, P2 : {6075}  
	int x_n = 12;
	
	// Nombre de valeurs generees (au moins 10 periodes)
	long int N = 10e4;
	
	// Tableaux pour stockage de valeurs generees
	float r_generes[N];
	
	// Compteur de répétitions
	int cpt = 1;
	
	// Longueur de la période du RNG
	int periode = 0;
	
	// Variable contenant r de reference
	float r_reff = 0;
	
	// Moyenne des valeurs generees
	float r_moy = 0;
	
	// Auto-correlation
	float R = 0;
	int tau = 1;
	float r_t[2] = {0, 0}; // {indice, r_t}
	
	// Début de generations de nombres
	printf("Début\n\n");
	
	for (int i = 0; i < N; i++)
	{
		// Appel du generateur
		float x = LC_RNG(k, l, m, x_n);
		
		// Calcul du nombre aleatoire genere
		float r = x/m;
		
		// Stockage du r genere
		r_generes[i] = r;
		
		// Ajout du nombre genere a la moyenne
		r_moy += r;
		
		if (i == 0)
		{
			// Stockage de la valeur de reference
			r_t[1] = r_reff = r;
		}
		
		if (i-r_t[0] == tau)
		{
			// Ajout de r_t*r_(t + tau) a l'auto-correlation
			R += r_t[1]*r;
			
			// MAJ r_t
			r_t[0] = i;
			r_t[1] = r; 
		}
		
		// Condition pour periode
		if (i != 0 && r == r_reff)
		{
			//printf("Répétition n°= %d | Position n°= %d\n\n", cpt, i);
			
			if(cpt == 1)
			{
				periode = i;
			}
			cpt += 1;
			
		}
		
		// Ecriture de r dans le fichier
		fprintf(fp, "%d %f\n", i+1, r);
		
		// MAj de x_n
		x_n = x;
	}
	
	// Calcul moyenne
	r_moy /= N;
	
	// Calcul auto-correlation
	R /= N;
	
	// Calcul coefficient de correlation
	float C;
	float R_tau = 0;
	float R_0 = 0;
	
	for (int i = 0; i <= N - tau; i++)
	{
		R_tau += ( r_generes[i] - r_moy) * (r_generes[i + tau] - r_moy);
		R_0 += ( r_generes[i] - r_moy ) * ( r_generes[i] - r_moy );
	}
	
	C = R_tau/R_0;
	
	// Fermeture fichier
	fclose(fp); 
	
	printf("\nPériode : %d\n\n", periode);
	printf("\nMoyenne des valeurs générées : %f\n\n", r_moy);
	printf("\nAuto-corrélation des valeurs générées : R(%d) = %f\n\n", tau, R);
	printf("\nTaux de corrélation : C(%d) = %f\n\n", tau, C);
	
	printf("\nFin\n\n");

	return 0;
}

float LC_RNG(int k, int l, int m, int x_n)
{
	return (k*x_n + l) % m;
}
