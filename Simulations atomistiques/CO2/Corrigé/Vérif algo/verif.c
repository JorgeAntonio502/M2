#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

float epsilon = 1.;
float sigma = 1.;

float Lennard_Jones(float r, float L)
{
    float Rc = L/2.; 
    //printf("Rc = %f, r = %f\n", Rc, r);
    
    if (r <= Rc)
    {
    	return 4.*epsilon*(pow(sigma/r, 12) - pow(sigma/r, 6) - pow(sigma/Rc, 12) + pow(sigma/Rc, 6));
    }
    else
    {
    	return 0;
    }
    

}


int main()
{
    int n = 10; // Nombre de particules
    int D = 2; // Dimension du problème
    int N;  // Nombre itérations
    int L = 50; // taille de la boîte (carrée)
    float mass = 1.; // masse des particules
    float t_ref = 0.05; // temps de référence
	
    float dt = 0.000001; //* sqrt(sigma*sigma*mass/epsilon);
    float E_0 = 0.; // L'énergie totale théorique
    float E_N = 0.; // Energie dy système à l'itération N
    	
    float x[n][D];  // positions
    float v[n][D];  // vitesses
    float x_init[n][D];
    float v_init[n][D];

    // Initialisation du générateur aléatoire de nombre

    time_t t;
    srand((unsigned) time(&t));

    // Creation des positions initiales de chaque particule

    printf("Positions initiales\n");

    for(int i = 0 ; i < n ; i++)
    {
        for(int j = 0; j < D; j++)
        {
            x_init[i][j] = (float) (rand() % L);
            x[i][j] = x_init[i][j];
            
            printf("%f\n", x_init[i][j]);
            printf("\n");
        }
    }

    // Creation des vitesses initiales

    printf("Vitesses initiales\n");
    printf("\n");

    for(int i = 0 ; i < n ; i++)
    {
        for(int j = 0; j < D; j++)
        {
            v[i][j] = (float) (rand() % L); // norme de la composante
            
            float sign = rand()%2; // signe de la composante
            if (sign == 0)
            {
            	v[i][j] = -v[i][j];
            }
            
            v_init[i][j] = v[i][j];
            
            
            printf("%f\n", v_init[i][j]);
            printf("\n");
        }
    }
    
    
    
    //calcul de l'énergie initiale E_0
    float vit_i = 0.;
    for (int i = 0; i < n; i++)
    {
    	vit_i = 0.;
    	for (int j = 0; j < D; j++)
    	{
    		if (i != j) // Exclusion de j
                {
                    float r_ij = 0.; // Distance entre les particules i et j

                    for (int l = 0; l < D; l++)
                    {
                        r_ij += pow(x[i][l] - x[j][l], 2);
                    }

                    r_ij = sqrt(r_ij); // Calcul final de r_jk

                    // Ajout de l'énergie potentielle entre i et j à l'énergie totale E_0 initiale
                    E_0 += Lennard_Jones(r_ij, L); 
                }
    	}
    	
    	for (int l = 0; l < D; l++)
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
	    for(int i = 0 ; i < n ; i++)
	    {
		for(int j = 0; j < D; j++)
		{
		    x[i][j] = x_init[i][j];
		    //printf("%f\n", x[i][j]);
		    v[i][j] = v_init[i][j];
		    //printf("%f\n", v[i][j]);
		    //printf("\n");
		}
	    }
	    
	    for (int i = 0; i < N; i++) // Parcours des N itérations
	    {
	    	// Energie du systeme au tour N
	    	E_N = 0.;
	    	
		for (int j = 0; j < n; j ++) // Parcours des n particules
		{
		    // vitesse de la particule j au tour N
		    float vit_j = 0.;
			
		    float F_j[D]; // Vecteur force exercé sur la particule j par les autres particules
		    // Mise à 0
		    for (int e = 0; e < D; e++)
		    {
		        F_j[e] = 0.;
		    }

		    for (int k = 0; k < n; k++) // Parcours des autres particules
		    {
		        if (j != k) // Exclusion de j
		        {
		            float r_jk = 0.; // Distance entre les particules j et k

		            for (int l = 0; l < D; l++)
		            {
		                r_jk += pow(x[k][l] - x[j][l], 2);
		            }

		            r_jk = sqrt(r_jk); // Calcul final de r_jk

		            // Ajout de l'énergie potentielle entre j et k à l'énergie totale (LJ)
		            E_N += Lennard_Jones(r_jk, L);

			     // Ajout des composantes de la force exercée par k sur j dans F
		            for (int l = 0; l < D; l++) 
		            {
		                F_j[l] += (4.*epsilon*( 12.*pow(sigma, 12)/pow(r_jk, 13) - 6.*pow(sigma, 6)/pow(r_jk, 7) )) * ((x[k][l]- x[j][l]))/(r_jk)*mass;
		            }
		        }
		    }

		    // Calcul des nouvelles coordonnées de x et v 
		    for (int l = 0; l < D; l++)
		    {
		    	// Euler
		        x[j][l] += dt * v[j][l];
		        v[j][l] += dt * F_j[l]; 

		        if ((x[j][l] < 0)) // Vérification conditions aux limites (périodiques)
		        {
		            x[j][l] = L;
		        }
		        if ((x[j][l] > L))
		        {
		            x[j][l] = 0;
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
	   
	    dt = dt*10.; // on augmente dt
    
    }
	
    fclose(fptr); // fermeture fichier des données
    
    printf("\nFin\n");

    return 0;
}
