// vectorisation-loops-check.c

/* 
README : vectorise a non-vectorisable loop via a temporary array with re-indexing

compile/run as gcc -O2 -fopt-info-vec -fopt-info-vec-missed vectorisation-reindexation.c  && time ./a.out  
 */

#include <stdio.h>
#include <assert.h>


int main() {	  

  const int dim=100000;
  double A[dim];
  double B[dim];
  double C[dim];

  // initialise array
  for (int i=0; i<dim; i++)
    A[i] = 1./(i+1);
  
  // temporary array
  for (int i = 0; i < dim; i++)
  {
  	B[i] = (i+1);
  }

  // calculate required sum
  double S=0;
  for (int i=0; i<dim; i++)
    S += B[i]*A[i] + (1./B[i]) * A[dim-i-1]; 
  

  printf("S: %lf",S); // dummy print
}
