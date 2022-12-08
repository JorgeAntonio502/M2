#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

/*#########################
Variables globales
#########################*/

// Variables unites reduites
float epsilon = 1.;
float sigma = 1.;
float K_B = 1.; //1.380649e-23;

// Constantes
const int D = 2; // Dimension du problème
const int N = 5;  // Nombre de cycles de MC
const int N_particules = 100; // Nombre de particules

// Rayon et energie de coupure
double Rcut = 2.5; 
double Ucut = 4*epsilon*pow(sigma/Rcut, 12) - 4*epsilon*pow(sigma/Rcut, 6);

// Parametres cristal
float L = 9 + 2*Rcut; // taille de la boîte de simulation (carrée)
float dl = (L-2*Rcut)/9;//pow(2,(double) 1/6) * sigma; // distance entre les molecules du cristal
double half_box = L/2;
float T = 0.01; // Température en Kelvins



/*#########################
Prototypes des fonctions
#########################*/

// fonction min()
double min(double a, double b);

// Creation du cristal
void create_squared_crystal(double pos[N_particules][D]);

// Calcule l'energie potentielle entre deux particules P et M (tableaux 2D)
double compute_Ep(double P[D], double M[D]);

// Modifie dx et dy selon le deplacement envisage
void displacement(double x, double y, double *dx, double *dy, double norm); 

// calcule probabilité de deplacement
void compute_probability(double E_initial, double E_final, double T, double *P);

// Validation ou non du deplacement
void validation(double P, double E_initial, double E_final, double *nb_displacement_accepted, double *E_moy, double pos[D], double initial_position[D]);

/*#########################
Fonction principale
#########################*/
int main()
{
	// Initialisation fichiers pour positions et grandeurs mesurees
    FILE *fptr;    // positions
    FILE *fp;      // Ep
    
    fptr = fopen("Positions.txt", "w");

    if (fptr == NULL) {
		printf("File error\n");
		exit(1);
	}
	
    // ouverture fichier pour les energies
    fp = fopen("Potential_Energy.txt", "w");

    if (fp == NULL) {
		printf("File error\n");
		exit(1);
	}
	
	printf("L = %f\n\n", L);
	
	// Declaration constantes
    double V = L*L;
    float norm = 1; // Longueur max des deplacements selon x et y
    float P_tentative = 1/N; // Proba de tenter de deplacer 1 particule 
    
    // Tableaux
    double initial_position[D]; // stockage de la position avant deplacement
    double pos[N_particules][D]; // tableau des positions
    
    // Variables
    double x, y; // Pour placement des particules
    double dx = 0, dy = 0; // deplacements selon x et y
    double P; // probabilite de conserver le deplacement
    int selection; // indice de la particule selectionnee
    
    // Variables pour statistiques
    double Ep_i = 0., Ep_f = 0.; // pour comparaison des energies
    double Ep_moy = 0.; // Pour moyenne de Ep sur un cycle de MC
    double nb_displacement_accepted = 0; // compte les acceptations
    double nb_total_attemps = N*N_particules; // N_particules tentatives par cycle de MC
    
    // RNG (module rand())
    time_t t;
    srand((unsigned) time(&t));
    
    
    
    
    // Creation du cristal
    printf("Création cristal initial\n");
    create_squared_crystal(pos);
    printf("Cristal créé\n\n");
    
    // Ecriture configuration initiale
	for(int i =0; i < N_particules; i++)
	{
		fprintf(fptr, "%f	%f\n", pos[i][0], pos[i][1]);
	}
	fprintf(fptr, "\n\n");
	
	
   
    
	// Boucle principale de la simulation :
    printf("Début METROPOLIS\n\n");
    
    // Parcours des N cycles MC
    for(int i = 0; i < N; i++) 
    {
    	// Boucle des N_particules tentatives
    	for(int j = 0; j < N_particules; j++)
    	{
			// Calcul energie potentielle totale initiale
			for(int k = 0; k < N_particules-1; k++)
			{
				for(int l = k+1; l < N_particules; l++)
				{
					Ep_i += compute_Ep(pos[k], pos[l])/2;
					/*
					if(i == 0 && j == 0)
					{
						printf("Ep_i = %f\n", Ep_i);
					}
					*/
				}
			}
			
			// Ecriture energie initiale
			if(i == 0 && j == 0)
			{
				fprintf(fp, "# E_initiale = %f\n\n", Ep_i);
			}
			
			// Choix au hasard de la particule a deplacer
			selection = (int) rand() % N_particules;
			
			// Stockage position initiale de cette particule
			initial_position[0] = pos[selection][0];
			initial_position[1] = pos[selection][1];
			
			// Definition du deplacement (dx, dy) de cette particule
			displacement(pos[selection][0], pos[selection][1], &dx, &dy, norm);
			
			// Application du deplacement
			pos[selection][0] += dx;
			pos[selection][1] += dy;
			
			// Calcul de l'energie potentielle totale suite au deplacement
			for(int k = 0; k < N_particules-1; k++)
			{
				for(int l = k+1; l < N_particules; l++)
				{
					Ep_f += compute_Ep(pos[k], pos[l])/2;
				}
			}
			
			printf("%f	%f\n", Ep_i, Ep_f);
			
			// Calcul probabilité d'acceptation
			compute_probability(Ep_f, Ep_i, P_tentative, &P);
			
			// Validation ou non du deplacement
			//printf("P = %f, ", P);
			validation(P, Ep_i, Ep_f, &nb_displacement_accepted, &Ep_moy, pos[selection], initial_position);
			
			// Remise a 0 de Ep_i et Ep_f pour tentaive suivante
			Ep_i = 0;
			Ep_f = 0;
			
			
			// Ecriture configuration
			for(int i =0; i < N_particules; i++)
			{
				fprintf(fptr, "%f	%f\n", pos[i][0], pos[i][1]);
			}
			fprintf(fptr, "\n\n");
			
    	}
    	/*
    	// Ecriture configuration apres chaque cycle MC
		for(int i =0; i < N_particules; i++)
		{
			fprintf(fptr, "%f	%f\n", pos[i][0], pos[i][1]);
		}
		fprintf(fptr, "\n\n");
    	*/
    	
    	// Ecriture de Ep_moy dans fichier
    	Ep_moy /= N_particules;
    	fprintf(fp, "%d	%f\n", i+1, Ep_moy);
    	
    	// Remise a 0 de Ep_i et Ep_f
    	Ep_moy = 0;
    }
    
    
    
    // Fermeture fichiers :
    fclose(fptr); 
    fclose(fp);
    
    printf("\n\n Nombre de tentatives de déplacements acceptées : %f\n Nombre total de tentatives (Nombre de particules * Nombre de cycles MC) : %f \n Pourcentage de déplacements acceptés : %f \n\n", nb_displacement_accepted, nb_total_attemps, (nb_displacement_accepted/nb_total_attemps) * 100);
    
	printf("\n\nFin de simulation\n");
	
	return 0;
}



/*#############################
Codes des differentes fonctions
#############################*/

// Fonction min() pour METROPOLIS
double min(double a, double b)
{
	return (a > b) ? b : a;
}

// Creation cristal cerre ordonne
void create_squared_crystal(double pos[N_particules][D])
{
	int cpt = 0; // Pour initialiser pos
	double x, y; // Pour calcul des positions
    
    // Creation des positions
    for(int i = 0 ; i < 10 ; i++)
    {
        for(int j = 0; j < 10; j++)
        {
       		cpt += 1;
       		
       		// coordonnees de la particule
            x = Rcut + (double) i * dl;
            y = Rcut + (double) j * dl;
            
            // Ecriture positions dans pos
            pos[cpt-1][0] = x;
            pos[cpt-1][1] = y;
        }
    }
}

// Calcul de l'énergie potentielle entre deux particules P et M
double compute_Ep(double P[D], double M[D])
{
	double Ep = 0.;
	double r;
	
	double xp = P[0];
	double yp = P[1];
	
	
	// Application des conditions aux limites periodiques
	
	// Selon x
	if(M[0]-P[0] >= half_box)
	{
		xp += L;
	}
	else if(M[0]-P[0] < half_box)
	{
		xp -= L;
	}
	// Selon y
	if(M[1]-P[1] >= half_box)
	{
		yp += L;
	}
	else if(M[1]-P[1] < half_box)
	{
		yp -= L;
	}
	
	// Calcul de la distance r entre les deux particules
	r = sqrt((M[0]-xp)*(M[0]-xp) + (M[1]-yp)*(M[1]-yp));
	//printf("%f\n", r);
	
	// Lennaard_Jones tronque-decale
	if(r < Rcut)
	{
		Ep =  4*epsilon*pow(sigma/r, 12) - 4*epsilon*pow(sigma/r, 6) - Ucut;
	}
	
	return Ep;
}


// Deplacements aleatoires selon x et y de longueur max egale a "norm"
void displacement(double x, double y, double *dx, double *dy, double norm)
{
	// Booleen pour validite du deplacement
	bool accepted = 0;
	
	// Boucle modifiant dx et dy jusqu'a validite du deplacement
	do
	{
		// Valeurs aleatoires de dx et dy
		*dx = norm * (double) rand()/ (double)RAND_MAX;
		*dy = norm * (double) rand()/ (double)RAND_MAX;
				
			// Definiton du signe de dx
			float coeff = ((float) (rand() % 100) + 1.) / 100; // valeur entre 0 et 1
				
			if(coeff <= 0.5)
			{
				*dx = -*dx;
			}
				
			// Definiton du signe de dy
			coeff = ((float) (rand() % 100) + 1.) / 100; // valeur entre 0 et 1
				
			if(coeff <= 0.5)
			{
				*dy = -*dy;
			}
			
			// Verification que la particule ne sort pas de la boite de simulation
			if( (x+*dx >= 0 && x+*dx <= L) && (y+*dy >= 0 && y+*dy <= L) )
			{
				accepted = 1;
			}
			
	} 
	while(!accepted);
}

// Calcul probabilite du deplacement envisage
void compute_probability(double E_initial, double E_final, double T, double *P)
{
	if (E_final < E_initial)
	{
		*P = 1;
	}
	else
	{
		*P = T * exp( -(E_final-E_initial) / (K_B*T) );
	}
}

// Validation du deplacement envisage
void validation(double P, double E_initial, double E_final, double *nb_displacement_accepted, double *E_moy, double pos[D], double initial_position[D])
{
	// nombre entre 0 et 1
	float coeff = ((float) (rand() % 100) + 1.) / 100;
	//printf("coeff = %f\n", coeff);
			
	if(coeff > P)
	{
		pos[0] = initial_position[0];
		pos[1] = initial_position[1];
				
		// Ajout de Ep_i a E_moy
		*E_moy += E_initial; 
	}
	else
	{
		*nb_displacement_accepted += 1;
				
		// Ajout de Ep_f a E_moy
		*E_moy += E_final; 
	}
}
