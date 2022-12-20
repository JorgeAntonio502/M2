#!/bin/bash
#SBATCH --job-name job
#SBATCH --output md.out
#SBATCH --nodes 1 
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --partition umformation
#SBATCH --account  f_m2pn

# Alternative
##SBATCH --ntasks 4
##SBATCH --cpus-per-task=1

# OpenMP runtime settings
#export OMP_DYNAMIC=FALSE
#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Alternative
export OMP_NUM_THREADS=$SLURM_NTASKS

echo "Running on: $SLURM_NODELIST"
echo "SLURM_NTASKS=$SLURM_NTASKS"
echo "SLURM_NTASKS_PER_NODE=$SLURM_NTASKS_PER_NODE"
echo "SLURM_CPUS_PER_TASK=$SLURM_CPUS_PER_TASK"
echo "SLURM_CPUS_ON_NODE=$SLURM_CPUS_ON_NODE"

time ./a.out params.txt 
