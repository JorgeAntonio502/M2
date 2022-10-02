#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main( int argc, char *argv[] )  {

   clock_t start, end;
   double t;

   int i;
   int N = 1000000000;
   
   FILE *fp;
   fp = fopen("data.dat", "w");
   
   if (fp == NULL)
   {
   	printf("Error");
   	exit(1);
   }
   
   while (N < 2000000000)
   {
   	printf("N = %d\n", N);
   	start = clock(); // début enregistrement
   
	for (i = 0; i < N; i++)
	{
	    2.2*8.5;
	}
	   
	end = clock(); // fin enregistrement
	   
	t = ((double) (end - start)) / CLOCKS_PER_SEC; // Calcul du temps de calcul total
	
	fprintf(fp, "%d\t%0.20f\n", N, t/(double) N);
	
	N += 100000000;
   }
   
   fclose(fp);
   
   return 0;
}
