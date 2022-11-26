
void write_xyz (FILE *fp, int ndim, int n, double pos[]) {
  int i, j;
  fprintf(fp, "%d\n", n);
  fprintf(fp, "\n");
  for (j=0; j<n/2; j++) {
    fprintf(fp, "A %f %f %f\n",  pos[j*ndim],  pos[j*ndim+1],  pos[j*ndim+2]);
  }
  for (j=n/2; j<n; j++) {
    fprintf(fp, "B %f %f %f\n",  pos[j*ndim],  pos[j*ndim+1],  pos[j*ndim+2]);
  }
}
