#include <stdio.h> 
#include <time.h>

int main() {

  clock_t start, end;
  double t;

  const int N=10000;
  
  const int dim=100;
  double a [dim][dim];
  double b [dim][dim];
  
  start = clock();
  
  for (int n=0; n<N; n++) {
    
    for  (int i=0; i<dim; i++){ 
      for (int j=0; j<dim; j++) { 
    	b[i][j] = a[i][j];
      }
    }

  }
  
  end = clock();
  
  t = ((double) end - start) / CLOCKS_PER_SEC;

  printf("a[0] = %lf, t_1 = %e s ",a[0][0], t/N);
  return 0;
}
