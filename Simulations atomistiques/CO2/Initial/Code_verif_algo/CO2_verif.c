#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

// sqrt(pow(x[j][0] - x[k][0], 2) + pow(x[j][1] - x[k][1], 2));
// (4.*epsilon*( 12.*pow(sigma, 13)/pow(r, 13) - 6.*pow(sigma, 6)/pow(r, 7) ) * (float) (x[k+1][l]- x[j][l]))/mass;

int main()
{
    int n = 5; // Nombre de particules
    int D = 2; // Dimension du problème
    int N;  // Nombre itérations pour arriver à dt
    int i, j, k, l, e; // indices de boucle

    // Constantes du problème :

    float epsilon = 1.;
    float sigma = 1.;
    float mass = 1.;
    float dt = 0.0001; //* sqrt(sigma*sigma*mass/epsilon);
    float t_ref = 0.5; // temps de référence 
    float E_0 = 0.; // L'énergie totale théorique
    float E_N = 0.; // Energie dy système à l'itération N

    // Dimension de la boîte selon x et y
    float x_min = 0.;
    float x_max = 50.;

    float x[n][D];  // positions
    float v[n][D];  // vitesses
    float x_init[n][D];
    float v_init[n][D];

    // Initialisation du générateur aléatoire de nombre

    time_t t;
    srand((unsigned) time(&t));

    // Creation des positions initiales de chaque particule


    printf("Positions initiales\n");

    for(i = 0 ; i < n ; i++)
    {
        for(j = 0; j < D; j++)
        {
            x_init[i][j] = (float) (rand() % (int) (x_max - x_min));
            x[i][j] = x_init[i][j];
            printf("%f\n", x[i][j]);
            printf("\n");
        }
    }

    // Creation des vitesses initiales

    printf("Vitesses initiales\n");
    printf("\n");

    for(i = 0 ; i < n ; i++)
    {
        for(j = 0; j < D; j++)
        {
            v_init[i][j] = (float) (rand() % (int) (x_max - x_min));
            v[i][j] = v_init[i][j];
            printf("%f\n", v[i][j]);
            printf("\n");
        }
    }
    
    //calcul de l'énergie initiale E_0
    float vit_i = 0.;
    for (i = 0; i < n; i++)
    {
    	vit_i = 0.;
    	for (j = 0; j < D; j++)
    	{
    		if (i != j) // Exclusion de j
                {
                    float r_ij = 0.; // Distance entre les particules i et j

                    for (l = 0; l < D; l++)
                    {
                        r_ij += pow(x[i][l] - x[j][l], 2);
                    }

                    r_ij = sqrt(r_ij); // Calcul final de r_jk

                    // Ajout de l'énergie potentielle entre i et j à l'énergie totale E_0 initiale
                    E_0 += 4*epsilon*(pow(sigma/r_ij, 12) - pow(sigma/r_ij, 6)); 
                }
    	}
    	
    	for (l = 0; l < D; l++)
            {
                // Ajout du caré de la composante à la vitesse de j
                vit_i +=  v[i][l]*v[i][l];
            }
            // Calcul final de la valeur de la vitesse de j
            vit_i = sqrt(vit_i);
            
            // Ajout de l'énergie cinétique de j à l'énergie totale
            E_0 += mass*vit_i*vit_i/2.;
    }
    printf("\nE_0 = %f\n", E_0);


    // initialisation ouverture fichiers
    FILE *fptr;
    
    // ouverture fichier des positions en mode écriture
    fptr = fopen("data.dat", "w");

    if (fptr == NULL) {
		printf("File error\n");
		exit(1);
	}
	


    printf("Debut\n");
    printf("\n");
    
    
    while ((dt < t_ref)) // boucle sur dt 
    {
    
	    N = t_ref/dt; // Nombre d'itérations pour arriver à t_ref
	    printf("dt = %f, N = %d\n", dt, N);
	    
	    // Récupération des conditions initiales des positions et des vitesses
	    //printf("\nRéinitialisation des positions et vitesses\n");
	    for(i = 0 ; i < n ; i++)
	    {
		for(j = 0; j < D; j++)
		{
		    x[i][j] = x_init[i][j];
		    //printf("%f\n", x[i][j]);
		    v[i][j] = v_init[i][j];
		    //printf("%f\n", v[i][j]);
		    //printf("\n");
		}
	    }

	    for (i = 0; i < N; i++) // Parcours des N itérations
	    {
	    	// Energie du systeme au tour N
	    	E_N = 0.;
	    	
		for (j = 0; j < n; j ++) // Parcours des n particules
		{
		    // vitesse de la particule j au tour N
		    float vit_j = 0.;
			
		    float F_j[D]; // Force exercée sur la particule j
		    // Mise à 0
		    for (e = 0; e < D; e++)
		    {
		        F_j[e] = 0.;
		    }

		    for (k = 0; k < n; k++) // Parcours des autres particules
		    {
		        if (j != k) // Exclusion de j
		        {
		            float r_jk = 0.; // Distance entre les particules j et k

		            for (l = 0; l < D; l++)
		            {
		                r_jk += pow(x[k][l] - x[j][l], 2);
		            }

		            r_jk = sqrt(r_jk); // Calcul final de r_jk

		            // Ajout de l'énergie potentielle entre j et k à l'énergie totale (LJ)
		            E_N += 4*epsilon*(pow(sigma/r_jk, 12) - pow(sigma/r_jk, 6)); 

			     // Ajout des composantes de la force exercée par k sur j dans F
		            for (l = 0; l < D; l++) 
		            {
		                F_j[l] += (4.*epsilon*( 12.*pow(sigma, 12)/pow(r_jk, 13) - 6.*pow(sigma, 6)/pow(r_jk, 7) )) * ((x[k][l]- x[j][l]))/(r_jk);
		            }
		        }
		    }

		    // Calcul des nouvelles coordonnées de x et v et vérification des conditions aux limites
		    for (l = 0; l < D; l++)
		    {
		    	// Euler
		        x[j][l] += dt * v[j][l];
		        v[j][l] += dt* F_j[l]; 

		        if ((x[j][l] <= x_min || x[j][l] >= x_max )) // Vérification conditions aux limites
		        {
		            if (x[j][l] <= x_min)
		            {
		                x[j][l] = x_min;
		            }
		            if (x[j][l] >= x_max)
		            {
		                x[j][i] = x_max;
		            }
		            v[j][l] = -v[j][l];
		        }
		        
		        // Ajout du carré de la composante à la vitesse de j
		        vit_j +=  v[j][l]*v[j][l];
		    }
		    // Calcul final de la valeur de la vitesse de j
		    vit_j = sqrt(vit_j);
		    
		    // Ajout de l'énergie cinétique de j à l'énergie totale
		    E_N += mass*vit_j*vit_j/2.;
		}
		
	    }
	    
	    printf("%f\t%f\n\n", dt, fabs(E_N-E_0));
	    fprintf(fptr, "%f\t%f\n\n", logf(dt), logf(fabs(E_N-E_0)));
	    
	    dt = dt*1.5; // on augmente dt d'un ordre de grandeur
	    
    }

    fclose(fptr); // fermeture fichier des données
    
    printf("\nFin\n");

    return 0;
}
