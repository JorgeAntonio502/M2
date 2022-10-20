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
int n = 15; // Nombre de particules
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

float compute_force(float P[2], float M[2])
{
	float r;
	float F[2] = {0, 0};
	float E_p = 0;
	
	float xp = P[0];
	float yp = P[1];
	
	// Test sur les x
	if (M[0]-P[0] > L/2)
	{
		xp += L;
	}
	else if (M[0]-P[0] < -L/2)
	{
		xp -= L;
	}
	
	// Test sur les y 
	if (M[1]-P[1] > L/2)
	{
		yp += L;
	}
	else if (M[1]-P[1] < -L/2)
	{
		yp -= L;
	}
	
	r = sqrt((M[0]-xp)*(M[0]-xp) + (M[1]-yp)*(M[1]-yp));
	
	E_p = Lennard_Jones(r)/2;
	
	if (r < Rc)
	{
		F[0] = dLennard_Jones(r) * ( (P[0]- M[0]) )/r;
		F[1] = dLennard_Jones(r) * ( (P[1]- M[1]) )/r;
		return F[0], F[1], E_p;
	}
	
	return F[0], F[1], E_p;
	
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
    float F_t[n][D]; // tableau contenant les forces à l'instant t
    
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
    	
    	// Premier parcours des n particules pour les positions
        for (int j = 0; j < n; j ++) 
        {
        	// Vecteur force exercé sur la particule j par les autres particules à t
            float F_j[D] = {0, 0}; // à t
            
            // Parcours des autres particules et calcul de f_t à partir de x_t
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
					
		     		// Calcul des composantes de la force exercée par k sur j
		     		
                    for (int l = 0; l < D; l++) 
                    {
                        F_j[l] += dLennard_Jones(r_jk) * ( (x[k][l]- x[j][l]) )/r_jk;
                    }
                    
                    // Ajout des éventuelles forces et énergies dues au conditions aux limites périodiques 
                    
                    //F_j[0], F_j[1], E_pN += compute_force(x[j], x[k]);
                }
            }
            
            // Stockage de la force exercée sur j à t
            F_t[j][0] = F_j[0];
            F_t[j][1] = F_j[1];

            // Calcul des nouvelles valeurs x_t pour j
            for (int k = 0; k < D; k++)
            {
            	// Velocity Verlet pour les positions
                x[j][k] += dt * v[j][k] + 0.5*F_j[k]*dt*dt;

                if ((x[j][k] < 0)) // Vérification conditions aux limites (périodiques)
                {
                    x[j][k] = L;
                }
                if ((x[j][k] > L))
                {
                    x[j][k] = 0;
                }
                
                // Ecriture de la composante de x_t+1 dans le fichier dédié
                fprintf(fptr, "%f\t", x[j][k]); 
            }
            
            fprintf(fptr, "\n"); // Retour à la ligne pour l'écriture de la nouvelle position de j+1 à l'itération N
        }
        
		E_pN = 0.;
        
        // Second parcours des n particules pour les vitesses
        for (int j = 0; j < n; j ++) 
        {
            // vitesse de la particule j au tour N
            float vit_j = 0.;
        	
        	// Vecteur force exercé sur la particule j par les autres particules
            float F_jsup[D] = {0, 0}; // à t+1
            
            // Parcours des autres particules et calcul de f_t+1 à partir de x_t+1
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
					
					E_pN += Lennard_Jones(r_jk)/2; // Ajout de l'énergie potentielle entre j et k à l'énergie potentielle à t+1 
					
		     		// Calcul des composantes de la force exercée par k sur j
		     		
                    for (int l = 0; l < D; l++) 
                    {
                        F_jsup[l] += dLennard_Jones(r_jk) * ( (x[k][l]- x[j][l]) )/r_jk;
                    }
                    
                    // Ajout des éventuelles forces et énergies dues au conditions aux limites périodiques 
                    
                    //F_jsup[0], F_jsup[1], E_pN += compute_force(x[j], x[k]);
                }
            }

            // Calcul des nouvelles valeurs v_t+1 pour j
            for (int k = 0; k < D; k++)
            {
            	// Velocity Verlet pour les vitesses
                v[j][k] += dt/2 * (F_t[j][k] + F_jsup[k]);
                
                // Ajout composante vitesse à vitessse de j
                vit_j += v[j][k]*v[j][k];
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

