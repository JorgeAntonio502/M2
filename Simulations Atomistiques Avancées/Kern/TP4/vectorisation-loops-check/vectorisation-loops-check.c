// vectorisation-loops-check.c

/* 
README : illustrate caveats when trying to vectorise loops
compile/run as gcc -O2 -fopt-info-vec -fopt-info-vec-missed vectorisation-loops-check.c  && time ./a.out  
 */

#include <stdio.h>
#include <assert.h>

int f(int i,int imax) {
  return (i<imax)*27;
}
    

int main() {	  

  const int dim=100000;
  int x[dim];
  int y[dim];

  // #0: ok
  for (int i=0; i<dim; i++)
    x[i]=dim-i-1;
  
  // loop #1: ok
  for (int i=0; i<dim; i++)
    x[i] *=i;
  
  // loop #2: no
  const int k=10;
  assert(k>=0);
  assert(k<dim/2);
  for (int i=dim/2; i<dim; i++)
    x[i]=x[i-2]; // dummy operation
  
  // loop #3: not reported, but no
  for (int i=0; f(i,dim)>0; i++)
    x[i]+=2;  

  // loop #4: n
  for (int i=0; i<dim; i++) {
    if (i>0)
      x[i]+=2;
  }

  // loop #5: ok
  for (int i=0; i<dim; i++)
    x[i]+=f(x[i],dim);  

  // loop #5: ok
  for (int i=0; i<dim; i++)
    x[i]+=y[i];  


  // loop #6: no
  for (int i=0; i<dim; i++)
    x[i]+=x[y[i]];  

  printf("k: %d",k); // dummy print
}
