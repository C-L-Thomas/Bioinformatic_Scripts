module load gcc/12.3.0
module load cuda12.1/toolkit
module load cudnn8.9-cuda12.1

# Change directory to the directory from which the job was submitted:
cd $SLURM_SUBMIT_DIR

dorado-0.9.1-linux-x64/bin/dorado demux \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --output-dir 4mc,5mc,6ma \
  4mc,5mc,6ma.bam 

