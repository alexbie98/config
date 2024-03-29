#!/bin/bash

# Set the port number for Jupyter Notebook
PORT=1972

# Remove existing nb.log file, if it exists
rm -f nb.log

# Check if the argument is provided
if [ -z "$1" ]; then
  echo "ERROR: No argument provided. Please specify 'cpu' or 'gpu'."
  exit 1
elif [ "$1" == "gpu" ]; then
  echo "STARTING GPU NOTEBOOK"
  JOB_ID=$(sbatch nb_gpu.sbatch | awk '{print $4}')
elif [ "$1" == "cpu" ]; then
  echo "STARTING CPU NOTEBOOK"
  JOB_ID=$(sbatch nb_cpu.sbatch | awk '{print $4}')
else
  echo "ERROR: Invalid argument. Please specify 'cpu' or 'gpu'."
  exit 1
fi

# Wait for the nb.log file to be created and for the Jupyter server to start
while [ ! -f nb.log ]; do
  sleep 1
done

# Wait until the Jupyter URL appears in the log
while ! grep -q "http://localhost:${PORT}/?token=" nb.log; do
  sleep 1
done

# Extract and display the URL
URL=$(grep "http://localhost:${PORT}/?token=" nb.log | head -1 | awk '{print $NF}')
echo "| URL:"
echo "$URL"

# Extract the node name and construct the SSH command
NODE=$(squeue --job $JOB_ID --noheader --format=%N)
SSH_COMMAND="ssh -t -t user@cluster.ai -L ${PORT}:localhost:${PORT} ssh -N $NODE -L ${PORT}:localhost:${PORT}"
echo "| SSH COMMAND:"
echo "$SSH_COMMAND"
