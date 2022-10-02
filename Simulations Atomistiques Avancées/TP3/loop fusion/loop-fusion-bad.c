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
            a[i]=1;                     

        for (i=0; i<ndim; i++)
            b[i]=2;
    }
    
    end = clock();
    
    t = ((double) end - start) / CLOCKS_PER_SEC;
    
    printf("%d, t_1 = %e", b[0], t/niter);
   return 0;
}


