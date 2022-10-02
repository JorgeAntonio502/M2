#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

const double Rc = 2.5; // Le rayon de troncature 
double epsilon = 1.;
double mass = 1.;
int N = 10000000;


void interactions(double x1, double y1, double x2, double y2, double &u12, double &f12x, double &f12y)
{
	// distance entre 1 et 2
	
	double r_12 = sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2));
	
	// Calcul de l'énergie d'interaction
	
	float a = (Rc/r_12)*(Rc/r_12)*(Rc/r_12); // cube
	float b = a*a; // puissance 6
	float c = b*b; // puissance 12
	
	//u12 = 4*epsilon*(pow(Rc/r_12, 12) - pow(Rc/r_12 ,6));
	u12 = 4*epsilon*(c - b);
	
	// Calcul des résultantes de la force de 1 sur 2
	
	a = Rc*Rc*Rc;
	b = a*a;
	c = b*b;
	
	float d = r_12*r_12*r_12;
	float e = d*d;
	float f = e*e;
	
	f12x = (4.*epsilon*( 12.*(c/f*r_12) - 6.*(b/e*r_12) ) * (float) (x2- x1))/mass;
	f12y = (4.*epsilon*( 12.*(c/f*r_12) - 6.*(b/e*r_12) ) * (float) (y2- y1))/mass;
	
	//f12x = (4.*epsilon*( 12.*pow(Rc, 12)/pow(r_12, 13) - 6.*pow(Rc, 6)/pow(r_12, 7) ) * (float) (x2- x1))/mass;
	//f12y = (4.*epsilon*( 12.*pow(Rc, 12)/pow(r_12, 13) - 6.*pow(Rc, 6)/pow(r_12, 7) ) * (float) (y2- y1))/mass;
	
}


int main( int argc, char *argv[] )  
{
	clock_t start, end;
	double t;

	double x1 = 1.2, x2 = 2.3, y1 = 3.1, y2 = 2.; // Les positions des particules 1 et 2
	double u12; // Le potentiel d'interaction de 1 sur 2
	double f12x, f12y; // les composantes de la force de 1 sur 2
   
	start = clock(); // Début enregistrement du temps
	
	for (int i = 0; i < N; i++)
	{ 
		interactions(x1, y1, x2, y2, u12, f12x, f12y);
	}
	
	end = clock(); // fin enregistrement
	   
	t = ((double) end - start) / CLOCKS_PER_SEC; // Calcul du temps de calcul total
   
	printf("temps de calcul : %e s\n", t/float(N));
   
	return 0;
}
