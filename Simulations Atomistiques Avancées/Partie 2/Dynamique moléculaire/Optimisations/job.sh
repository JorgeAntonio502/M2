#!/bin/bash
#SBATCH --job-name=test1
#SBATCH --output job.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=umformation
#SBATCH --account=f_m2pn

echo "Running on": $SLURM_NODELIST
echo "Number of tasks:" $SLURM_NTASKS
echo "Number of tasks per node:" $SLURM_NTASKS_PER_NODE
time ./a.out params_fmdw.txt 

