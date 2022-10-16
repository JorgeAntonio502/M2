#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int D = 2; // Dimension du problème
int N;  // Nombre itérations
int L = 10; // taille de la boîte (carrée)
float epsilon = 1.;
float sigma = 1.;
float Rc = 2.5;
int n = 7; // Nombre de particules
float mass = 1.; // masse des particules (g)
float T = 3.; // Température en Kelvins
float R = 8314.; // g.m2.s-2.mol-1.K-1 (fois 1000 pour avoir des grammes comme la masse des particules)

// Différentes fonctions utilisées :

float Lennard_Jones(float r)
{
	if (r < Rc)
	{
    	return 4*epsilon*(pow(sigma/r, 12) - pow(sigma/r, 6)) - 4*epsilon*(pow(sigma/Rc, 12) - pow(sigma/Rc, 6));
    }
    else
    {
    	return 0;
    }
}

float dLennard_Jones(float r)
{
	return 4*epsilon*(6*( pow(sigma, 6)/pow(r, 7) ) - 12*( pow(sigma, 12)/pow(r, 13) ) );
}

// Fonction principale :

int main()
{
    float V = L*L*L; // Volume
    float dt = 0.001; // pas temporel
    float dt_ref = dt;
    float t_ref = 0.4; // temps de référence du premier max de E_tot
    float E_pN = 0.; // Energie potentielle à N
    float E_kN = 0.; // Energie cinétique à N
    
    float x[n][D] = {{7.000000, 4.000000}, {8.000000, 5.000000}, {3.000000, 4.000000}, {1.000000, 2.000000}, {5.000000, 2.000000}, {2.000000, 0.000000}, {3.000000, 6.000000}}; // tableau contenant les positions
    float v[n][D] = {{0.062790, -0.876307}, {0.187381, -0.998027}, {-0.125333, 0.125333}, {-0.951056, -0.728969}, {0.992115, -0.425779}, {0.992115, -0.309017}, {0.684547, -0.187381}}; // tableau contenant les vitesses
    float E_0 = 2.046938;
    
    // La norme de la vitesse moyenne des particules est déduite de la température choisie
    float n_gaz = n/V; // Quantité de matière (mol)
    float M_molarMass = n*mass;//n*mass/n_gaz; // Masse molaire (g.mol-1)
    float v_rms = 1; // vitesse moyenne des particules du gaz
    
    // Création et ouverture en mode écriture du fichier pour récupération de données
    
    FILE *fpData;
    fpData = fopen("Data.txt", "w");
    
    if (fpData == NULL) {
		printf("File error\n");
		exit(1);
	}
    
    //FILE *fptr;    // positions
    //FILE *fp;      // Energies
    
    /*
    fptr = fopen("Positions.txt", "w");

    if (fptr == NULL) {
		printf("File error\n");
		exit(1);
	}
	
    // ouverture fichier pour les énergies
    fp = fopen("Energy.txt", "w");

    if (fp == NULL) {
		printf("File error\n");
		exit(1);
	}
	*/
	
	// Début de la simulation :
    
    printf("Debut\n\n");
    
    while (dt < t_ref)
    {
    	N = t_ref/dt; // Calcul du nombre d'térations pour arriver à t_ref par saut de dt
    	printf("dt = %f, N = %d\n", dt, N);
    	
		for (int i = 0; i < N; i++) // Parcours des N itérations
		{
			// Mise à zéro des énergie au tour N
			E_pN = 0.;
			E_kN = 0.;
			
			// Parcours des n particules :
		    for (int j = 0; j < n; j ++) 
		    {
		        // vitesse de la particule j au tour N
		        float vit_j = 0.;
		    	
		    	// Vecteur force exercé sur la particule j par les autres particules
		        float F_j[D]; 
		        for (int e = 0; e < D; e++)
		        {
		            F_j[e] = 0.;
		        }
		        
		        // Parcours des autres particules :
		        for (int k = 0; k < n; k++) 
		        {
		            if (j != k) // Exclusion de j
		            {
		                float r_jk = 0; // Distance entre les particules j et k
		                
		                for (int l = 0; l < D; l++)
						{
							r_jk += pow(x[k][l] - x[j][l], 2);
						}
						
						r_jk = sqrt(r_jk);

		                E_pN += Lennard_Jones(r_jk); // Ajout de l'énergie potentielle entre j et k à l'énergie potentielle   

				 		// Calcul des composantes de la force exercée par k sur j dans F
		                for (int l = 0; l < D; l++) 
		                {
		                    F_j[l] += (dLennard_Jones(r_jk)) * ( (x[k][l]- x[j][l]) )/(r_jk);
		                }
		            }
		        }

		        // Calcul des nouvelles valeurs de x et v 
		        for (int l = 0; l < D; l++)
		        {
		        	// Euler
		            x[j][l] += dt * v[j][l];
		            v[j][l] += dt * F_j[l]; 
		            
		            // Ajout du carré de la composante à la vitesse de j
		            vit_j +=  v[j][l]*v[j][l];

		            if ((x[j][l] < 0)) // Vérification conditions aux limites (périodiques)
		            {
		                x[j][l] = L;
		            }
		            if ((x[j][l] > L))
		            {
		                x[j][l] = 0;
		            }
		            
		            // Ecriture de la composante de position calculée pour j à l'itération N dans le fichier dédié
		            //fprintf(fptr, "%f\t", x[j][l]); 
		        }
		        
		        vit_j = sqrt(vit_j); // Calcul final de la valeur de la vitesse de j
		        
		        E_kN += mass*vit_j*vit_j/2.; // Ajout de l'énergie cinétique de j à l'énergie cinétique
		        
		        //fprintf(fptr, "\n"); // Retour à la ligne pour l'écriture de la nouvelle position de j+1 à l'itération N
		    }
		    //fprintf(fptr, "\n\n"); // Double saut de ligne pour l'écriture des positions à l'itération N + 1
		    
		}
		
		printf("%f\t%f\n\n", dt, fabs((E_pN + E_kN)-E_0));
		// Ecriture des données dans le fichier
		fprintf(fpData, "%f\t%f\n\n", logf(dt), logf(fabs((E_pN + E_kN)-E_0)));
		
		dt = 1.5*dt ; // incrément de dt 
	}
    
    printf("dt = %f, N = %d\n", dt, N);
    
    // Fermeture fichiers :
    //fclose(fptr); 
    //fclose(fp);
    fclose(fpData);
    
	printf("\nFin\n");
	
	return 0;
}
