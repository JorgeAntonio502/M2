#include <stdio.h>
#include <time.h>

int main() {

    clock_t start, end;
    float t;

    long int ndim=10000;
    long int niter=10000;
 
    int a[ndim], b[ndim];
    
    start = clock();

    for (long int n=0; n<niter; n++) {

        long int i;
        
        for (i=0; i<ndim; i++)
        { 
          a[i]=1; 
          b[i]=2; 
        }                   
            
    }
    
    end = clock();
    
    t = ((double) end - start) / CLOCKS_PER_SEC;
    
    printf("\n%d, t_1 = %e\n\n", b[0], t/niter);
   return 0;
}


