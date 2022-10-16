#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int D = 2; // Dimension du problème
int N = 1000;  // Nombre itérations
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
		float ratio3_r = (sigma/r)*(sigma/r)*(sigma/r);
		float ratio6_r = ratio3_r*ratio3_r;
		
		float ratio3_Rc = (sigma/Rc)*(sigma/Rc)*(sigma/Rc);
		float ratio6_Rc = ratio3_Rc*ratio3_Rc;
		
		return 4*epsilon*(ratio6_r*ratio6_r - ratio6_r) - 4*epsilon*(ratio6_Rc*ratio6_Rc - ratio6_Rc);
    	//return 4*epsilon*(pow(sigma/r, 12) - pow(sigma/r, 6)) - 4*epsilon*(pow(sigma/Rc, 12) - pow(sigma/Rc, 6));
    }
    else
    {
    	return 0;
    }
}

float dLennard_Jones(float r)
{
	float r7 = r*r*r*r*r*r*r;
	float r13 = r7*r*r*r*r*r*r;
	
	return 4*epsilon*(6*(sigma/r7) - 12*(sigma/r13));
	//return 4*epsilon*(6*( pow(sigma, 6)/pow(r, 7) ) - 12*( pow(sigma, 12)/pow(r, 13) ) );
}

// Fonction principale :

int main()
{
    float V = L*L*L; // Volume
    float dt = 0.001; // pas temporel
    float E_pN = 0.; // Energie potentielle à N
    float E_kN = 0.; // Energie cinétique à N
    
    float x[n][D]; // tableau contenant les positions
    float v[n][D]; // tableau contenant les vitesses
    
    // La norme de la vitesse moyenne des particules est déduite de la température choisie
    float n_gaz = n/V; // Quantité de matière (mol)
    float M_molarMass = n*mass;//n*mass/n_gaz; // Masse molaire (g.mol-1)
    float v_rms = 1; // vitesse moyenne des particules du gaz
    
    
    // Création des positions initiales :
    
    FILE *fpinit; // Fichier contenant la situation initiale
    fpinit = fopen("InitialConditions.txt", "w");

    if (fpinit == NULL) {
		printf("File error\n");
		exit(1);
	}
    
    time_t t;
    srand((unsigned) time(&t));
    
    printf("Création des positions initiales\n");
    fprintf(fpinit, "positions initiales :\n");
    
    for(int i = 0 ; i < n ; i++)
    {
        for(int j = 0; j < D; j++)
        {
            x[i][j] = (float) (rand() % L);
            
            if (j == 0)
            {
            	fprintf(fpinit, "{%f, ", x[i][j]);
            }
            else
            {
            	fprintf(fpinit, "%f}, ", x[i][j]);
            }
        }
    }
    
    
    // Création des vitesses initiales :
    
    printf("Création des vitesses initiales\n");
    fprintf(fpinit, "\n\nvitesses initiales :\n");
    
    for(int i = 0 ; i < n ; i++)
    {
        for(int j = 0; j < D; j++)
        {
            float coeff = ((float) (rand() % 100) + 1.) / 100; // valeur aléatoire entre 0 et 2pi
            
            if (j == 0) // Pour x
            {
            	v[i][j] = v_rms * cos(coeff*2.* M_PI);
            	fprintf(fpinit, "{%f, ", v[i][j]);
            }
            else // Pour y
            {
            	v[i][j] = v_rms * sin(coeff*2.* M_PI);
            	fprintf(fpinit, "%f}, ", v[i][j]);
            }
        }
    }
    
    
    // Création et ouverture en mode écriture des fichiers pour positions et énergies
    
    FILE *fptr;    // positions
    FILE *fp;      // Energies
    
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
	
	// Début de la simulation :
    
    printf("Debut\n\n");
    
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
						r_jk += (x[k][l] - x[j][l])*(x[k][l] - x[j][l]);
					}
					
					r_jk = sqrt(r_jk);

                    E_pN += Lennard_Jones(r_jk); // Ajout de l'énergie potentielle entre j et k à l'énergie potentielle   

		     		// Calcul des composantes de la force exercée par k sur j dans F
                    for (int l = 0; l < D; l++) 
                    {
                        F_j[l] += (dLennard_Jones(r_jk)) * ( (x[k][l]- x[j][l]) )/r_jk;
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
                fprintf(fptr, "%f\t", x[j][l]); 
            }
            
            vit_j = sqrt(vit_j); // Calcul final de la valeur de la vitesse de j
            
            E_kN += mass*vit_j*vit_j/2.; // Ajout de l'énergie cinétique de j à l'énergie cinétique totale à N
            
            fprintf(fptr, "\n"); // Retour à la ligne pour l'écriture de la nouvelle position de j+1 à l'itération N
        }
        fprintf(fptr, "\n\n"); // Double saut de ligne pour l'écriture des positions à l'itération N + 1
        
        // Ecriture des éneries dans leurs fichiers respectifs
        fprintf(fp, "%f\t%f\t%f\t%f\n", i*dt, E_pN + E_kN, E_pN, E_kN);
        
        if (i == 0)
        {
        	fprintf(fpinit, "\n\nE_0 = %f", E_pN + E_kN);
        }
    }
    
    // Fermeture fichiers :
    fclose(fptr); 
    fclose(fp);
    fclose(fpinit);
    
	printf("\nFin\n");
	
	return 0;
}

