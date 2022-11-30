#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

/*#########################
Variables globales
#########################*/

const int D = 2; // Dimension du problème
const int N = 1000;  // Nombre de cycles de MC
float L = 9; // taille de la boîte de simulation (carrée)
double half_box = L/2;
const int N_particules = 100; // Nombre de particules
 
float epsilon = 1.;
float sigma = 1.;
float K_B = 1.380649e-23;

// Rayon et energie de coupure
double Rcut = 2.5; 
double Ucut = 4*epsilon*( pow(sigma/Rcut, 12) - pow(sigma/Rcut, 6) );

float dl = L/10; // distance entre les molecules du cristal

float T = 3.; // Température en Kelvins



/*#########################
Prototypes des fonctions
#########################*/

// fonction min()
double min(double a, double b);

// Calcule l'energie potentielle entre deux particules P et M (tableaux 2D)
double compute_Ep(double P[D], double M[D]);

// Modifie dx et dy selon le deplacement envisage
void displacement(double x, double y, double *dx, double *dy, double norm); 



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
	
	
	
	// Declaration constantes
    double V = L*L;
    float norm = L/2; // Longueur max des deplacements selon x et y
    float P_tentative = 1; // Proba de tenter de deplacer 1 particule 
    
    // Tableaux
    double initial_position[D]; // stockage de la position avant deplacement
    double pos[N_particules][D]; // tableau des positions
    
    // Variables
    double x, y; // Pour placement des particules
    double dx = 0, dy = 0; // deplacements selon x et y
    double P; // probabilite de conserver le deplacement
    int selection; // indice de la particule selectionnee
    int cpt = 0; // utile pour initialiser pos
    
    // Variables pour statistiques
    double Ep_i = 0., Ep_f = 0.; // pour comparaison des energies
    double Ep_moy = 0.; // Pour moyenne de Ep sur un cycle de MC
    double nb_displacement_accepted = 0;
    double nb_total_attemps = N*N_particules; // N_particules tentatives par cycle de MC
    
    // RNG (module rand())
    time_t t;
    srand((unsigned) time(&t));
    
    
    
    
    // Creation des positions initiales (configuration carree ordonnee)
    printf("Création cristal initial\n");
    for(int i = 0 ; i < 10 ; i++)
    {
        for(int j = 0; j < 10; j++)
        {
       		cpt += 1;
       
            x = 1 + (double) i * dl;
            y = 1 + (double) j * dl;
            
            // Ecriture positions dans pos
            fprintf(fptr, "%f	%f\n", x, y);
            
            pos[cpt-1][0] = x;
            pos[cpt-1][1] = y;
        }
    }
    fprintf(fptr, "\n\n");
    printf("Cristal créé\n\n");
    
    
    
    
	// Boucle principale de la simulation :
    printf("Début METROPOLIS\n\n");
    
    // Parcours des N cycles MC
    for(int i = 0; i < N; i++) 
    {
    	// Boucle des N_particules tentatives
    	for(int j = 0; j < N_particules; j++)
    	{
			// Calcul energie potentielle totale initiale
			for(int k = 0; k < N_particules; k++)
			{
				Ep_i += compute_Ep(pos[j], pos[k])/2;
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
			
			// Definition du deplacement de cette particule
			displacement(pos[selection][0], pos[selection][1], &dx, &dy, norm);
			
			// Application du deplacement
			pos[selection][0] += dx;
			pos[selection][1] += dy;
			
			// Calcul de l'energie potentielle totale suite au deplacement
			for(int k = 0; k < N_particules; k++)
			{
				Ep_f += compute_Ep(pos[j], pos[k])/2;
			}
			
			// Calcul probabilité d'acceptation (METROPOLIS)
			if (Ep_f < Ep_i)
			{
				P = 1;
			}
			else
			{
				P = P_tentative * min(1, exp( -(Ep_f-Ep_i) / K_B*T ) );
			}
			
			// Validation ou non du deplacement
			float coeff = ((float) (rand() % 100) + 1.) / 100;
			
			if(coeff > P)
			{
				pos[selection][0] = initial_position[0];
				pos[selection][1] = initial_position[1];
				
				// Ajout de Ep_i a E_moy
				Ep_moy += Ep_i; 
			}
			else
			{
				nb_displacement_accepted += 1;
				
				// Ajout de Ep_f a E_moy
				Ep_moy += Ep_f; 
			}
			
			// Remise a 0 de Ep_i et Ep_f pour tentaive suivante
			Ep_i = 0;
			Ep_f = 0;
			
			/*
			// Ecriture configuration
			for(int i =0; i < N_particules; i++)
			{
				fprintf(fptr, "%f	%f\n", pos[i][0], pos[i][1]);
			}
			fprintf(fptr, "\n\n");
			*/
    	}
    	
    	// Ecriture configuration apres chaque cycle MC
		for(int i =0; i < N_particules; i++)
		{
			fprintf(fptr, "%f	%f\n", pos[i][0], pos[i][1]);
		}
		fprintf(fptr, "\n\n");
    	
    	// Ecriture de Ep_moy dans fichier
    	Ep_moy /= N_particules;
    	fprintf(fp, "%d	%f\n", i, Ep_moy);
    	
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
	
	// Lennaard_Jones tronque-decale
	if(r < Rcut)
	{
		Ep =  4*epsilon*( pow(sigma/r, 12) - pow(sigma/r, 6) ) - Ucut;
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


