#!/bin/bash

#SBATCH --nodes=1
#SBATCH --gpus-per-node=1
#SBATCH --partition=single
#SBATCH --job-name=nb
#SBATCH --output=nb.log

# Run the following on the compute node
unset XDG_RUNTIME_DIR

PORT=1972

jupyter-notebook --no-browser --port=$PORT

