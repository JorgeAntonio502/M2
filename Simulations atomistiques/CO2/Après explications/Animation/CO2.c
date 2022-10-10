#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

float epsilon = 1.;
float sigma = 1.;
float N_Avogadro = 6.02214076e23;
int n = 5; // Nombre de particules
float mass = 1.; // masse des particules (g)
float T = 293.; // Température en Kelvins
float R = 8314.; // g.m2.s-2.mol-1.K-1 (fois 1000 pour avoir des grammes comme la masse des particules)

float Lennard_Jones(float r, float L)
{
    float Rc = 2.56;  // Rayon de troncature (2.56 ?)
    float rho = n*mass/L*L*L; // Densité moyenne
    
    if (r <= Rc)
    {
    	float u_tail = (8/3)*M_PI*epsilon*rho*sigma*sigma*sigma*( (pow(sigma/Rc, 9)/3) - pow(sigma/Rc, 3) );
    	return 4.*epsilon*(pow(sigma/r, 12) - pow(sigma/r, 6) - pow(sigma/Rc, 12) + pow(sigma/Rc, 6)) + n*u_tail; // potentiel tronqué + correction de queue
    }
    else
    {
    	return 0;
    }
    

}


int main()
{
    int D = 2; // Dimension du problème
    int N = 500;  // Nombre itérations
    int L = 50; // taille de la boîte (carrée)
    float V = L*L*L;
    
    float n_gaz = n/V; // Quantité de matière (mol)
    float M_molarMass = n*mass;//n*mass/n_gaz; // Masse molaire (g.mol-1)
    float v_rms = sqrt(3*R*T/M_molarMass); // vitesse moyenne des particules du gaz
    printf("Root Mean Square velocity : %f m/s\n\n", v_rms);
    	
    float dt = 0.0001; //* sqrt(sigma*sigma*mass/epsilon);
    float E_0 = 0.; // L'énergie totale théorique
    float E_N = 0.; // Energie dy système à l'itération N
    	
    float x[n][D]; //= {{24., 34.}, {5., 48.}, {36., 49.}, {8., 29.}, {10., 13.}};  // positions
    float v[n][D]; //= {{-6., 15.}, {43., -15.}, {13., 33.}, {22., -34.}, {-22., -5.}};  // vitesses

    // Initialisation du générateur aléatoire de nombre

    time_t t;
    srand((unsigned) time(&t));

    // Creation des positions initiales de chaque particule
    
    FILE *fpv;
    fpv = fopen("Situation_initiale.txt", "w");

    if (fpv == NULL) {
		printf("File error\n");
		exit(1);
	}
    
    printf("Positions initiales\n");
    
    for(int i = 0 ; i < n ; i++)
    {
    	fprintf(fpv, "Position initiale de la particule numero : %d\n", i);
        for(int j = 0; j < D; j++)
        {
            x[i][j] = (float) (rand() % L);
            fprintf(fpv, "%f\n", x[i][j]);
            //printf("%f\n", x[i][j]);
            //printf("\n");
        }
        fprintf(fpv, "\n\n");
    }
    
    fprintf(fpv, "\n\n\n\n");

    // Creation des vitesses initiales

    printf("Vitesses initiales\n");
    printf("\n");

    for(int i = 0 ; i < n ; i++)
    {
    	fprintf(fpv, "Vitesse initiale de la particule numero : %d\n", i);
        for(int j = 0; j < D; j++)
        {
            float coeff = ((float) (rand() % 100) + 1.) / 100; // valeur aléatoire entre 0 et 2pi
            
            
            if (j == 0)
            {
            	v[i][j] = v_rms * cos(coeff*2.* M_PI);
            	//printf("%f\n\n", v[i][j]);
            }
            else
            {
            	v[i][j] = v_rms * sin(coeff*2.* M_PI);
            	//printf("%f\n\n", v[i][j]);
            }
            
            fprintf(fpv, "%f\n", v[i][j]);
            //printf("%f\n", v[i][j]);
            //printf("\n");
        }
        fprintf(fpv, "\n\n");
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
    fprintf(fpv, "\nE_0 = %f\n", E_0);
    
    fclose(fpv);
    
    
    // Ouverture fichiers pour positions et énergie
    FILE *fptr;
    FILE *fp;
    // ouverture fichier des positions en mode écriture
    fptr = fopen("positions.txt", "w");

    if (fptr == NULL) {
		printf("File error\n");
		exit(1);
	}
	
    // ouverture second fichier pour l'énergie
    fp = fopen("energy.txt", "w");

    if (fp == NULL) {
		printf("File error\n");
		exit(1);
	}
	

    printf("Debut\n");
    printf("\n");
	
	

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
                
                // Ecriture de la composante de vitesse calculée pour j à l'itération N
                fprintf(fptr, "%f\t", x[j][l]); 
                
                // Ajout du carré de la composante à la vitesse de j
                vit_j +=  v[j][l]*v[j][l];
            }
            // Calcul final de la valeur de la vitesse de j
            vit_j = sqrt(vit_j);
            
            // Ajout de l'énergie cinétique de j à l'énergie totale
            E_N += mass*vit_j*vit_j/2.;
            
            fprintf(fptr, "\n"); // Retour à la ligne pour l'écriture de la nouvelle position de j+1 à l'itération N
        }
        fprintf(fptr, "\n\n"); // Double saut de ligne pour l'itération N + 1
        fprintf(fp, "%f\t%f\n\n", i*dt, E_N);
    }

    fclose(fptr); // fermeture fichier positions
    fclose(fp); // fermeture fichier énergie
    
    
    printf("\nFin\n");
    
    return 0;
	
}
